;;; Code:
(require 'icomplete)
(require 'prescient-complete)


;; (vmacs-leader "fh" #'(lambda()(interactive)(let ((default-directory "~/"))(call-interactively 'find-file))))
;; (vmacs-leader "ft" #'(lambda()(interactive)(let ((default-directory "/tmp/"))(call-interactively 'find-file))))
;; (vmacs-leader "ff" 'find-file)
(setq completion-styles '(basic substring initials prescient flex))
;; (setq completion-category-overrides ;支持哪些stypes见completion-styles-alist
;;       '((file (styles initials basic))
;;         (buffer (styles initials basic))
;;         (info-menu (styles basic))))

(setq icomplete-prospects-height max-mini-window-height)
(setq icomplete-delay-completions-threshold 0)
(setq icomplete-max-delay-chars 0)
(setq icomplete-delay-completions-threshold 2000)
(setq icomplete-compute-delay 0)
(setq icomplete-show-matches-on-no-input t)
(setq icomplete-hide-common-prefix nil)
(setq icomplete-separator "\n")
;; (setq icomplete-with-completion-tables t)
(setq icomplete-in-buffer t)
(setq icomplete-tidy-shadowed-file-names t)
(icomplete-mode 1)
(define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions)
(define-key icomplete-minibuffer-map (kbd "C-s") #'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "C-r") #'icomplete-backward-completions)
(define-key icomplete-minibuffer-map (kbd "C-k") #'icomplete-fido-kill)
(define-key icomplete-minibuffer-map (kbd "C-m") #'icomplete-fido-ret)
(define-key icomplete-minibuffer-map (kbd "RET") #'icomplete-fido-ret)
;; (define-key icomplete-minibuffer-map [(control return)]   #'exit-minibuffer)
(define-key icomplete-minibuffer-map (kbd "C-j") #'exit-minibuffer) ;minibuffer-complete-and-exit
(define-key icomplete-minibuffer-map (kbd "M-j") #'icomplete-force-complete-and-exit)
(define-key icomplete-minibuffer-map (kbd "C-l") #'icomplete-fido-backward-updir)
(define-key icomplete-minibuffer-map (kbd "C-t") #'vmacs-icomplete-toggle-vertical)
(defun vmacs-icomplete-toggle-vertical ()
  "Toggle vertical view for `icomplete'."
  (interactive)
  (when (and (minibufferp)
             (bound-and-true-p icomplete-mode))
    (if (not (string= icomplete-separator "\n"))
        (setq icomplete-separator "\n")
      (setq icomplete-separator "  ⃝ "))))

(defun icomplete-mode-yank-pop ()
  (interactive)
  (let* ((icomplete-separator (concat "\n" (propertize "......" 'face 'shadow) "\n "))
         ;;disable sorting https://emacs.stackexchange.com/questions/41801/how-to-stop-completing-read-ivy-completing-read-from-sorting
         (completion-table
          (lambda (string pred action)
            (if (eq action 'metadata)
                '(metadata (display-sort-function . identity)
                           (cycle-sort-function . identity))
              (complete-with-action
               action kill-ring string pred)))))
    (insert
     (completing-read "Yank from kill ring: " completion-table nil t))))


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

;; ;; this macro works
;; ;; (macroexpand '(with-mode-on icomplete-mode (message "ss")))
;; (defmacro with-mode-on (mode &rest body)
;;   (declare (indent defun)
;;            (doc-string 3))
;;   (macroexp-let2 nil mode-p mode
;;     `(progn
;;        (unless ,mode-p (,mode 1))
;;        ,@body
;;        (unless ,mode-p (,mode -1)))))

;; ;; (macroexpand '(with-mode-off icomplete-mode (message "ss")))
;; (defmacro with-mode-off (mode &rest body)
;;   (declare (indent defun)
;;            (doc-string 3))
;;   (macroexp-let2 nil mode-p `(bound-and-true-p ,mode)
;;     `(progn
;;        (when ,mode-p (,mode -1))
;;        ,@body
;;        (when ,mode-p (,mode 1)))))


(provide 'conf-icomplete)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-icomplete.el ends here.
