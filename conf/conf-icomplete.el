;;; Code:
(require 'icomplete)

;; (setq orderless-component-separator " +")
;; (setq orderless-matching-styles '(orderless-regexp orderless-literal))

;; (setq icomplete-delay-completions-threshold 0)
;; (setq icomplete-max-delay-chars 3)
(setq icomplete-delay-completions-threshold 2000)
(setq icomplete-compute-delay 0)
(setq icomplete-show-matches-on-no-input t)
(setq icomplete-hide-common-prefix nil)
(setq icomplete-in-buffer t)
(setq icomplete-tidy-shadowed-file-names t)

(setq icomplete-prospects-height 15)
(setq icomplete-separator "\n")
;; (setq icomplete-separator (propertize " ⚫ " 'face  '(foreground-color . "SlateBlue1")))
;; 让第一个candidate不要显示在光标同一行，而是下一行

(if (fboundp 'fido-mode)
    (progn
      (fido-mode 1)
      (define-key icomplete-fido-mode-map (kbd "C-n") #'icomplete-forward-completions)
      (define-key icomplete-fido-mode-map (kbd "C-p") #'icomplete-backward-completions)
      (define-key icomplete-fido-mode-map (kbd "M-j") #'icomplete-force-complete-and-exit)
      (define-key icomplete-fido-mode-map (kbd "C-l") #'icomplete-fido-backward-updir)
      )
  (icomplete-mode 1))

(if (require 'orderless nil t)
    (setq completion-styles '(orderless partial-completion basic substring initials flex))
  (setq completion-styles '(basic substring initials partial-completion flex)))

;; (defun vmacs-fido-setup ())
;; (add-hook 'minibuffer-setup-hook #'vmacs-fido-setup 99)

(define-key icomplete-minibuffer-map (kbd "C-j") #'icomplete-fido-exit) ;minibuffer-complete-and-exit
;; (define-key icomplete-fido-mode-map (kbd "SPC") #'self-insert-command)

(defadvice yank-pop (around icomplete-mode (arg) activate)
  (interactive "p")
  (let ((icomplete-separator (concat "\n" (propertize (make-string 60 ?— ) 'face 'vertical-border) "\n ")))
    ad-do-it))



(provide 'conf-icomplete)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-icomplete.el ends here.
