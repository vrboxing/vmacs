;;; -*- coding:utf-8 -*-

(setq lsp-print-performance t)
(setq-default lsp-keymap-prefix "C-M-s-l")
;; (setq lsp-auto-configure t)
;; (setq lsp-enable-indentation nil)

(with-eval-after-load 'cc-mode
  (require 'ccls)
  (defun vmacs-cc-hook()
    (lsp-deferred)
    ;; (add-hook 'before-save-hook #'lsp-organize-imports 10 t)
    (add-hook 'before-save-hook #'lsp-format-buffer 20 t))
  (add-hook 'c-mode-hook 'vmacs-cc-hook)
  (add-hook 'c++-mode-hook 'vmacs-cc-hook)
  (add-hook 'objc-mode-hook 'vmacs-cc-hook))

(define-key evil-normal-state-map "gf" 'evil-jump-forward)
(define-key evil-normal-state-map "gb" 'evil-jump-backward)
(define-key evil-normal-state-map "gn" 'next-error)
(define-key evil-normal-state-map "gp" 'previous-error)
(evil-define-key '(normal visual operator motion emacs) 'global (kbd "<SPC>,") 'evil-jump-backward)  ;space, 回到上一个书签
(evil-define-key '(normal visual operator motion emacs) 'global (kbd "<SPC>.") 'evil-jump-forward)      ;space. 下一个书签

(define-key evil-motion-state-map "g." 'evil-jump-to-tag) ;对 xref-find-definitions 进行了包装
(define-key evil-motion-state-map "gr" 'lsp-find-references)
;; (define-key evil-motion-state-map "gd" 'evil-goto-definition);evil default,see evil-goto-definition-functions
;; (define-key evil-motion-state-map "gd" 'xref-find-references)
(define-key evil-motion-state-map "gi" 'lsp-find-implementation)
(define-key evil-normal-state-map "gi" 'lsp-find-implementation)
(define-key evil-motion-state-map "gc" 'lsp-find-implementation)
(define-key evil-motion-state-map "gR" 'lsp-rename)

(with-eval-after-load 'xref
  ;; (define-key xref--xref-buffer-mode-map (kbd "j") #'xref-next-line)
  ;; (define-key xref--xref-buffer-mode-map (kbd "k") #'xref-prev-line)
  (define-key xref--xref-buffer-mode-map (kbd "r") #'xref-query-replace-in-results)
  (define-key xref--xref-buffer-mode-map (kbd "TAB") #'xref-goto-xref)
  (define-key xref--xref-buffer-mode-map (kbd "<return>")  #'xref-quit-and-goto-xref)
  (define-key xref--xref-buffer-mode-map (kbd "RET")  #'xref-quit-and-goto-xref)

  (setq xref-show-xrefs-function 'completing-read-xref-show-defs)
  (setq xref-show-definitions-function 'completing-read-xref-show-defs)

  (defgroup completing-read-xref nil
    "Select xref results using completing-read."
    :prefix "completing-read-xref-"
    :group 'completing-read
    :link '(url-link :tag "Github" "https://github.com/jixiuf/completing-read-xref"))

  (defcustom completing-read-xref-use-file-path nil
    "Whether to display the file path."
    :type 'boolean
    :group 'completing-read-xref)

  (defcustom completing-read-xref-remove-text-properties nil
    "Whether to display the candidates with their original faces."
    :type 'boolean
    :group 'completing-read-xref)

  (defun completing-read-xref-make-collection (xrefs)
    "Transform XREFS into a collection for display via `completing-read'."
    (let ((collection nil))
      (dolist (xref xrefs)
        (with-slots (summary location) xref
          (let* ((line (xref-location-line location))
                 (file (xref-location-group location))
                 (candidate
                  (concat
                   (propertize
                    (concat
                     (if completing-read-xref-use-file-path
                         file
                       (file-name-nondirectory file))
                     (if (integerp line)
                         (format ":%d: " line)
                       ": "))
                    'face 'compilation-info)
                   (progn
                     (when completing-read-xref-remove-text-properties
                       (set-text-properties 0 (length summary) nil summary))
                     summary))))
            (push `(,candidate . ,location) collection))))
      (nreverse collection)))

;;;###autoload
  (defun completing-xref-show-xrefs (fetcher alist)
    "Show the list of xrefs returned by FETCHER and ALIST via completing-read."
    ;; call the original xref--show-xref-buffer so we can be used with
    ;; dired-do-find-regexp-and-replace etc which expects to use the normal xref
    ;; results buffer but then bury it and delete the window containing it
    ;; immediately since we don't want to see it - see #2
    (let* ((xrefs (if (functionp fetcher)
                      ;; Emacs 27
                      (or (assoc-default 'fetched-xrefs alist)
                          (funcall fetcher))
                    fetcher))
           (buffer (xref--show-xref-buffer fetcher alist)))
      (quit-window)
      (let* ((orig-buf (current-buffer))
             (orig-pos (point))
             (cands (completing-read-xref-make-collection xrefs))
             (candidate (completing-read "xref: "  cands nil t ))
             done)
        (setq candidate (assoc candidate cands))
        (condition-case err
            (let* ((marker (xref-location-marker (cdr candidate)))
                   (buf (marker-buffer marker)))
              (with-current-buffer buffer
                (select-window
                 ;; function signature changed in
                 ;; 2a973edeacefcabb9fd8024188b7e167f0f9a9b6
                 (if (version< emacs-version "26.0.90")
                     (xref--show-pos-in-buf marker buf t)
                   (xref--show-pos-in-buf marker buf)))))
          (user-error (message (error-message-string err)))))
      ;; honor the contact of xref--show-xref-buffer by returning its original
      ;; return value
      buffer))

;;;###autoload
  (defun completing-read-xref-show-defs (fetcher alist)
    "Show the list of definitions returned by FETCHER and ALIST via completing-read.
Will jump to the definition if only one is found."
    (let ((xrefs (funcall fetcher)))
      (cond
       ((not (cdr xrefs))
        (xref-pop-to-location (car xrefs)
                              (assoc-default 'display-action alist)))
       (t
        (completing-xref-show-xrefs fetcher
                                    (cons (cons 'fetched-xrefs xrefs)
                                          alist))))))

  )




(provide 'conf-tags)
