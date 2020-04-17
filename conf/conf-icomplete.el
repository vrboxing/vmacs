;;; Code:
(require 'icomplete)

(when (file-directory-p "~/.emacs.d/submodule/orderless")
  (add-to-list 'load-path "~/.emacs.d/submodule/orderless"))
(require 'orderless)
;; (require 'prescient)
;; (setq prescient-filter-method  '(literal regexp))
;; ;; to save your command history on disk, so the sorting gets more
;; ;; intelligent over time
;; (prescient-persist-mode 1)

;; (require 'prescient-complete)
(setq orderless-regexp-separator " +\\|[-/]")
(setq completion-styles '(orderless basic substring initials flex))
(setq completion-category-overrides
      '((file (styles . (orderless basic  substring flex)))
        (buffer (styles . (orderless basic substring )))
        (unicode-name (styles . (basic substring)))
        (project-file (styles . (substring)))
        (info-menu (styles . (basic substring)))))


;; (setq icomplete-delay-completions-threshold 0)
;; (setq icomplete-max-delay-chars 3)
(setq icomplete-delay-completions-threshold 2000)
(setq icomplete-compute-delay 0)
(setq icomplete-show-matches-on-no-input t)
(setq icomplete-in-buffer t)
(setq icomplete-tidy-shadowed-file-names t)

(setq icomplete-prospects-height 8)
;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24293
(setq icomplete-separator "\n")
;; (setq icomplete-separator (propertize " ⚫ " 'face  '(foreground-color . "SlateBlue1")))

(defun icomplete-vertical-minibuffer-setup ()
  "Setup minibuffer for a vertical icomplete session. Meant to be
added to `icomplete-minibuffer-setup-hook'."
  (if (not (string-match-p "\n" icomplete-separator))
      (setq truncate-lines nil)
    (setq truncate-lines t)
    (setq icomplete-hide-common-prefix nil)
    (enlarge-window (- icomplete-prospects-height (1- (window-height))))))

(add-hook 'icomplete-minibuffer-setup-hook #'icomplete-vertical-minibuffer-setup)

;; 让第一个candidate不要显示在光标同一行，而是下一行
(defun icomplete-vertical-format-completions (completions)
  "Reformat COMPLETIONS for better aesthetics.
To be used as filter return advice for `icomplete-completions'."
  (save-match-data
    (if (and (string-match "^\\((.*)\\|\\[.+\\]\\)?{\\(\\(?:.\\|\n\\)+\\)}"
                           completions)
             (string-match-p "\n" icomplete-separator))
        (format "%s \n%s"
                (or (match-string 1 completions) "")
                (match-string 2 completions))
      completions)))
(advice-add 'icomplete-completions :filter-return #'icomplete-vertical-format-completions)

;; (setq icomplete-with-completion-tables t)
(icomplete-mode 1)
(define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions)
(define-key icomplete-minibuffer-map (kbd "C-s") #'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "C-r") #'icomplete-backward-completions)
(define-key icomplete-minibuffer-map (kbd "C-k") #'icomplete-fido-kill)
(define-key icomplete-minibuffer-map (kbd "C-m") #'icomplete-fido-ret)
(define-key icomplete-minibuffer-map (kbd "RET") #'icomplete-fido-ret)
;; (define-key icomplete-minibuffer-map [(control return)]   #'exit-minibuffer)
(define-key icomplete-minibuffer-map (kbd "C-j") #'icomplete-fido-exit) ;minibuffer-complete-and-exit
(define-key icomplete-minibuffer-map (kbd "M-j") #'icomplete-force-complete-and-exit)
(define-key icomplete-minibuffer-map (kbd "C-l") #'icomplete-fido-backward-updir)
;; (define-key icomplete-minibuffer-map (kbd "SPC") #'self-insert-command)

(defun icomplete-mode-yank-pop ()
  (interactive)
  (let* ((icomplete-separator (concat "\n" (propertize (make-string 60 ?— ) 'face 'shadow) "\n "))
         ;;disable sorting https://emacs.stackexchange.com/questions/41801/how-to-stop-completing-read-ivy-completing-read-from-sorting
         (completion-table
          (lambda (string pred action)
            (if (eq action 'metadata)
                '(metadata (display-sort-function . identity)
                           (cycle-sort-function . identity))
              (complete-with-action
               action kill-ring string pred))))
         (selected (completing-read "Yank from kill ring: " completion-table nil t)))
    (if (eq major-mode 'vterm-mode)
        (vterm-send-string selected t)
      (insert selected))))


(defadvice yank-pop (around kill-ring-browse-maybe (arg) activate)
  "If last action was not a yank, run `browse-kill-ring' instead."
  ;; yank-pop has an (interactive "*p") form which does not allow
  ;; it to run in a read-only buffer. We want browse-kill-ring to
  ;; be allowed to run in a read only buffer, so we change the
  ;; interactive form here. In that case, we need to
  ;; barf-if-buffer-read-only if we're going to call yank-pop with
  ;; ad-do-it
  (interactive "p")
  (if (not (eq last-command 'yank))
      (icomplete-mode-yank-pop)
    ad-do-it))



(provide 'conf-icomplete)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-icomplete.el ends here.
