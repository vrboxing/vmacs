;; brew install libvterm
;; https://github.com/akermu/emacs-libvterm
;; mkdir -p build
;; cd build
;; cmake -DEMACS_SOURCE=~/repos/emacs ..
;; make
;; (setq-default vterm-keymap-exceptions '("C-c" "C-x" "C-u" "C-g" "C-h" "M-x" "M-o" "C-v" "M-v"))
(eval-when-compile (require 'evil))
(setq-default vterm-keymap-exceptions '("C-c" "C-x" "C-u" "C-g" "C-h" "M-x" "M-o" "C-y" ))
(require 'vterm)
(defun vterm-undo()
  (interactive)
  (vterm-send-key "_" nil nil t))


(define-key vterm-mode-map (kbd "s-t")   #'vterm)
(define-key vterm-mode-map (kbd "C-/")   #'vterm-undo)
(define-key vterm-mode-map (kbd "M-.")   #'vterm--self-insert)
(define-key vterm-mode-map (kbd "C-g")   #'vterm-ctrl-g)
(define-key vterm-mode-map (kbd "C-c C-g")   #'vterm--self-insert)
(define-key vterm-mode-map (kbd "s-v")   #'vterm-yank)
(define-key vterm-mode-map (kbd "C-k")   #'vterm-kill-line)

(defun vterm-ctrl-g ()
  "vterm ctrl-g"
  (interactive)
  (if (and (save-excursion (search-forward-regexp "[^\n \t]+" nil t))
           (save-excursion (not (search-forward-regexp vterm-prompt-regexp nil t))))
      (progn
        (unless (evil-insert-state-p)
          (evil-insert-state))
        (call-interactively 'vterm--self-insert))
    (if (equal last-command 'keyboard-quit)
        (progn
          (unless (evil-insert-state-p)
            (evil-insert-state))
          (call-interactively 'vterm--self-insert))
      (setq this-command 'keyboard-quit)
      (evil-normal-state)
      (call-interactively 'keyboard-quit))))

(defun vmacs-vterm-hook()
  (evil-define-key 'insert 'local (kbd "C-g") 'vterm-ctrl-g)
  (evil-define-key 'normal 'local "y" 'evil-yank-join)
  (evil-define-key 'motion'local "y" 'evil-yank-join)
  (evil-define-key 'visual 'local "y" 'evil-yank-join)
  (evil-define-key 'normal 'local (kbd "C-p") 'vterm--self-insert)
  (evil-define-key 'normal 'local (kbd "C-n") 'vterm--self-insert)
  (evil-define-key 'normal 'local (kbd "C-r") 'vterm--self-insert)
  (evil-define-key 'normal 'local (kbd "p") 'vterm-yank)
  (evil-define-key 'normal 'local (kbd "u") 'vterm-undo)

  (let ((p (get-buffer-process (current-buffer))))
    (when p
      (set-process-query-on-exit-flag p nil))))

(add-hook 'vterm-mode-hook 'vmacs-vterm-hook)
(defun vmacs-auto-exit(buf)
  (when buf (kill-buffer buf)))

(add-hook 'vterm-exit-functions #'vmacs-auto-exit)


(defvar vterm-user "")
(make-variable-buffer-local 'vterm-user)
(defvar vterm-host "")
(make-variable-buffer-local 'vterm-host)
(defvar vterm-pwd "")
(make-variable-buffer-local 'vterm-pwd)
(defvar vterm-cmd "")
(make-variable-buffer-local 'vterm-cmd)

;; # http://zsh.sourceforge.net/Doc/Release/Functions.html
;; # 刚打开shell时，也执行一次更新title
;; lastcmd=""
;; print -Pn "\e]0;%~@${USER}@${HOSTNAME}@${lastcmd}\a" #set title path@user@host@cmd
;; preexec () {
;;     lastcmd="$1"
;;     # # 标题栏、任务栏样式
;;     # 在执行命令前执行，所以此时打印的pwd可能不准,故还需要在chpwd里，刚更新一次
;;     print -Pn "\e]0;%~@${USER}@${HOSTNAME}@${lastcmd}\a" #set title path@user@host@cmd
;; }
;; chpwd() {
;;     # ESC]0;stringBEL — Set icon name and window title to string
;;     # ESC]1;stringBEL — Set icon name to string
;;     # ESC]2;stringBEL — Set window title to string
;;     print -Pn "\e]0;%~@${USER}@${HOSTNAME}@${lastcmd}\a" #set title path@user@host  chpwd里取不到当前cmd
;; }
(defun vterm-vterm-set-title-hook (title)
  ;; (message "%s" title)
  (let ((tokens (split-string title "@" )))
    (when (equal 4 (length tokens))
      (setq vterm-pwd (nth 0 tokens))
      (setq vterm-user (nth 1 tokens))
      (setq vterm-host (nth 2 tokens))
      (when (and (nth 3 tokens)
                 (not (string-empty-p (or (nth 3 tokens) ""))))
        (setq vterm-cmd (nth 3 tokens)))
      (setq default-directory
	        (file-name-as-directory
	         (if (and (string= vterm-host (system-name))
                      (string= vterm-user (user-real-login-name)))
		         (expand-file-name vterm-pwd)
               (concat "/-:" vterm-user "@" vterm-host ":"
                       vterm-pwd))))
      ;; (message "pwd=%s,user=%s,host=%s,cmd=%s d=%s"
      ;;          vterm-pwd vterm-user vterm-host vterm-cmd (or default-directory ""))
      (rename-buffer (vmacs-eshell--generate-buffer-name "vterm " (or vterm-cmd "") vterm-pwd ) t)
      )))

(add-hook 'vterm-set-title-functions 'vterm-vterm-set-title-hook)



(defvar  vterm-prompt-regexp "^[a-zA-Z0-9_-]+@[^#$%\n]*[#$%] *")

(defun vterm-skip-prompt ()
  "Skip past the text matching regexp `vterm-prompt-regexp'.
If this takes us past the end of the current line, don't skip at all."
  (let ((eol (line-end-position)))
    (when (and (looking-at vterm-prompt-regexp)
	           (<= (match-end 0) eol))
      (goto-char (match-end 0)))))


(defun vterm-get-line( &optional skip-prompt)
  (save-excursion
    (let ((start (point-at-bol))
          (end (point-at-eol))
          (width (window-body-width))
          text)
      (while (and (<= width (- (point-at-eol) (point-at-bol)))
                  (not (eobp)))
        (forward-line)
        (end-of-line)
        (setq end (point-at-eol)))
      (goto-char start)
      (forward-line -1)
      (while (and (<= width (string-width (buffer-substring-no-properties (point-at-eol) (point-at-bol) )))
                  (not (bobp)))
        (setq start (point-at-bol))
        (forward-line -1)
        (beginning-of-line))
      (setq text (buffer-substring start end))
      (with-temp-buffer
        (insert text)
        (goto-char (point-min))
        (when (looking-at vterm-prompt-regexp)
          (delete-region (point) (match-end 0)))
        (while  (search-forward-regexp "\n" nil t )
          (replace-match ""))
        (buffer-string)))))


(defun vterm-get-old-input-default ()
  "Default for `term-get-old-input'.
Take the current line, and discard any initial text matching
`term-prompt-regexp'."
  (vterm-get-line t))

(defun vterm-kill-line()
  (interactive)
  (save-excursion
    (let ((pos (point))
          (end (point-at-eol))
          (width (window-body-width))
          text)
      (while (and (<= width (string-width (buffer-substring-no-properties (point-at-eol) (point-at-bol) )))
                  (not (eobp)))
        (forward-line)
        (end-of-line)
        (setq end (point-at-eol)))
      (setq text (buffer-substring pos end))
      (with-temp-buffer
        (insert text)
        (goto-char (point-min))
        (while  (search-forward-regexp "\n" nil t )
          (replace-match ""))
        (kill-ring-save (point-min) (point-max)))))
  (call-interactively 'vterm--self-insert))



;; vterm内，会有原本是一行的内容，会硬折行为多行，
;; 此时yank 的时候，自动将其join为一行
(evil-define-operator evil-yank-join (beg end type register yank-handler)
  "try join wrapped lines then yank."
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (if current-prefix-arg
      (evil-yank beg end type register yank-handler)
    (let ((text (buffer-substring beg end))
          (width (window-body-width))
          break pt)
      (when (and (equal type 'line)
                 (equal (line-number-at-pos beg)
                        (line-number-at-pos (1- end))))
        (setq text (vterm-get-line)))
      (with-temp-buffer
        (insert text)
        (goto-char (point-min))
        (setq pt (point))
        (while (not break)
          (end-of-line)
          (if (eobp)
              (setq break t)
            (if (and (<= width (string-width (buffer-substring-no-properties pt (point))))
                     (looking-at-p "\n"))
                (progn
                  (delete-char 1)         ;delete \n
                  (setq pt (point)))
              (forward-char 1)            ;goto next bol
              (setq pt (point)))))
        (goto-char (point-min))
        (while (looking-at vterm-prompt-regexp)
          (delete-region (point) (match-end 0))
          (forward-line))
        (evil-yank (point-min) (point-max) type register yank-handler)))))

(provide 'conf-vterm)
