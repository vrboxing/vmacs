(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-initial-inputs-alist nil)
(setq ivy-extra-directories '("./")) ; default value: ("../" "./")
(setq ivy-wrap t)
(setq ivy-count-format "%d/%d ")
;; (setq ivy-virtual-abbreviate 'full) ; Show the full virtual file paths
;; (setq ivy-add-newline-after-prompt nil)
(setq ivy-height 25)
(setq ivy-fixed-height-minibuffer t)
(setq counsel-git-grep-skip-counting-lines t)
(setq ivy-re-builders-alist '((swiper . ivy--regex-plus)
                              (counsel-ag . ivy--regex-plus)
                              (counsel-git-grep . ivy--regex-plus)
                              (counsel-grep-or-swiper . ivy--regex-plus)
                              (t . ivy--regex-fuzzy)))

(setq counsel-git-grep-cmd-default "git --no-pager grep --full-name -n --no-color -i -e '%s'|cut -c -300") ;trunc long line

(setq magit-completing-read-function 'ivy-completing-read)
(setq counsel-find-file-at-point t)
(setq ivy-ignore-buffers
       (list
           "\\` "
           "\*Helm"
           "\*helm"
           "\*vc-diff\*"
           "\*magit-"
           "\*vc-"
           "*Backtrace*"
           "*Package-Lint*"
           ;; "todo.txt"
           "\*vc*"
           "*Completions*"
           "\*vc-change-log\*"
           "\*VC-log\*"
           "\*Async Shell Command\*"
           "\*Shell Command Output\*"
           "\*sdcv\*"
           ;; "\*Messages\*"
           "\*Ido Completions\*"))

;; (setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f1> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f1> u") 'counsel-unicode-char)
;; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history) ;M-:

(evil-leader/set-key "SPC" 'ivy-switch-buffer)
(evil-leader/set-key "ff" 'counsel-find-file)
(evil-leader/set-key "fl" 'counsel-locate)
(evil-leader/set-key "fg" 'counsel-git)
(evil-leader/set-key "g" 'vmacs-counsel-rg-region-or-symbol)
(evil-leader/set-key "fr" 'vmacs-counsel-git-grep-region-or-symbol)

(evil-leader/set-key "?" 'counsel-descbinds)
(evil-leader/set-key "wi" 'counsel-imenu)
(evil-leader/set-key "b" 'ivy-resume)
(evil-leader/set-key "wy" 'counsel-mark-ring)
(evil-leader/set-key ";" 'counsel-M-x)
(evil-leader/set-key "；" 'counsel-M-x)
;; (setq avy-timeout-seconds 0.3)
;; (evil-leader/set-key "o" 'avy-goto-char-timer)
;; (global-set-key  (kbd "s-o") 'avy-goto-char-timer)

;; From browse-kill-ring.el
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
      (counsel-yank-pop)
    (barf-if-buffer-read-only)
    ad-do-it))




(define-key ivy-minibuffer-map (kbd "C-c C-c") 'ivy-occur)
(define-key ivy-minibuffer-map (kbd "C-o") 'ivy-dispatching-done)
(define-key ivy-minibuffer-map (kbd "C-w") 'ivy-yank-word)
(define-key ivy-minibuffer-map (kbd "C-e") 'vmacs-ivy-magic-eol)
(define-key ivy-minibuffer-map (kbd "<tab>") 'ivy-partial-or-done)
(define-key ivy-minibuffer-map (kbd "C-l") 'ivy-backward-kill-word)
(define-key ivy-minibuffer-map (kbd "C-h") 'ivy-backward-kill-word)
;; (define-key ivy-minibuffer-map (kbd "C-;") 'ivy-avy)
;; (define-key ivy-minibuffer-map (kbd "C-[ [ a f") 'ivy-avy) ; ;iterm map C-; to this


(with-eval-after-load 'counsel
  (define-key counsel-find-file-map (kbd "C-l") 'counsel-up-directory)
  (define-key counsel-find-file-map (kbd "C-h") 'counsel-up-directory)
  ;; (define-key counsel-ag-map (kbd "C-l") 'counsel-up-directory)
  ;; (define-key counsel-ag-map (kbd "C-h") 'counsel-up-directory)
  ;; (define-key counsel-git-grep-map (kbd "C-h") 'counsel-up-directory)
  ;; (define-key counsel-git-grep-map (kbd "C-l") 'counsel-up-directory)


  (define-key counsel-find-file-map (kbd "<return>") 'ivy-alt-done)
  (define-key counsel-find-file-map (kbd "<RET>")      'ivy-alt-done))

(with-eval-after-load 'ivy-dired-history
  (define-key ivy-dired-history-map (kbd "<return>") 'ivy-done)
  (define-key ivy-dired-history-map (kbd "<RET>")      'ivy-done))


(ivy-add-actions 'counsel-find-file '(("d" vmacs-ivy-dired "dired")))
(ivy-add-actions 'ivy-switch-buffer '(("d" vmacs-ivy-swithc-buffer-open-dired "dired")))


(provide 'conf-ivy)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-ivy.el ends here.
