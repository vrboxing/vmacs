;;; -*- coding:utf-8 -*-
(setq eglot-confirm-server-initiated-edits nil)
(setq eglot-autoshutdown nil)
(setq eglot-sync-connect 0)
;; :documentHighlightProvider 禁用高亮光标下的单词
(setq eglot-ignored-server-capabilites '(:documentHighlightProvider))
(defun vmacs-lsp-hook()
  ;; (lsp-deferred)
  ;; (add-hook 'before-save-hook #'lsp-organize-imports 10 t)
  ;; (add-hook 'before-save-hook #'lsp-format-buffer 20 t)
  (add-hook 'after-save-hook #'eglot-organize-imports 29 t);before hook有时无效，只好After
  ;; (add-hook 'before-save-hook #'eglot-organize-imports -100 t)
  (add-hook 'before-save-hook #'eglot-format-buffer 30 t))

(dolist (mod '(python-mode-hook c++-mode-hook go-mode-hook c-mode-hook ))
  (add-hook mod 'eglot-ensure))
(dolist (mod '(go-mode-hook)) (add-hook mod 'vmacs-lsp-hook))
(with-eval-after-load 'eglot
  ;; brew install llvm
  ;;clangd https://clangd.llvm.org/installation.html
  ;; ln -s ~/myproject/compile_commands.json ~/myproject-build/
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "/usr/local/opt/llvm/bin/clangd")))

(define-key evil-normal-state-map "gf" 'evil-jump-forward)
(define-key evil-normal-state-map "gb" 'evil-jump-backward)
(define-key evil-normal-state-map "gn" 'next-error)
(define-key evil-normal-state-map "gp" 'previous-error)
(vmacs-leader (kbd ",") 'evil-jump-backward)  ;space, 回到上一个书签
(vmacs-leader (kbd ".") 'evil-jump-forward)      ;space. 下一个书签

(define-key evil-motion-state-map "g." 'evil-jump-to-tag) ;对 xref-find-definitions 进行了包装
;; (define-key evil-motion-state-map "gr" 'lsp-find-references)
(define-key evil-motion-state-map "gR" 'eglot-rename)
(define-key evil-motion-state-map "gr" 'xref-find-references)
(define-key evil-motion-state-map "gc" 'eglot-find-declaration)
(define-key evil-normal-state-map "gi" 'eglot-find-implementation)
(define-key evil-motion-state-map "gt" 'eglot-find-typeDefinition)
(define-key evil-motion-state-map "gs" 'eglot-reconnect)
(define-key evil-normal-state-map "gh" 'eglot-code-actions)
(define-key evil-normal-state-map "gp" 'evil-project-find-regexp)
(define-key evil-normal-state-map "gP" 'project-or-external-find-file)
;;
;; ;; (define-key evil-motion-state-map "gd" 'evil-goto-definition);evil default,see evil-goto-definition-functions
;; (define-key evil-motion-state-map "gi" 'lsp-find-implementation)
;; (define-key evil-motion-state-map "gR" 'lsp-rename)
(defun evil-project-find-regexp( &optional string _pos)
  (interactive)
  ;; (call-interactively 'vmacs-rg-dwim-project-dir)
  (project-find-regexp (or string (regexp-quote (thing-at-point 'symbol)))))

(setq evil-goto-definition-functions
      '(evil-goto-definition-xref  evil-project-find-regexp evil-goto-definition-imenu evil-goto-definition-semantic evil-goto-definition-search))

(with-eval-after-load 'xref
  (setq xref-search-program 'ripgrep)     ;project-find-regexp
  (when (functionp 'xref--show-defs-minibuffer)
    (setq xref-show-definitions-function 'xref--show-defs-minibuffer)
    (setq xref-show-xrefs-function 'xref--show-defs-minibuffer)))


(defun eglot-organize-imports ()
  "Offer to execute code actions `source.organizeImports'."
  (interactive)
  (unless (eglot--server-capable :codeActionProvider)
    (eglot--error "Server can't execute code actions!"))
  (let* ((server (eglot--current-server-or-lose))
         (actions (jsonrpc-request
                   server
                   :textDocument/codeAction
                   (list :textDocument (eglot--TextDocumentIdentifier)
                         :range (list :start (eglot--pos-to-lsp-position (point-min))
                                      :end (eglot--pos-to-lsp-position (point-max)))
                         :context
                         `(:diagnostics
                           [,@(cl-loop for diag in (flymake-diagnostics (point-min) (point-max))
                                       when (cdr (assoc 'eglot-lsp-diag (eglot--diag-data diag)))
                                       collect it)]))))
         (action (cl-find-if
                  (jsonrpc-lambda (&key kind &allow-other-keys)
                    (string-equal kind "source.organizeImports" ))
                  actions)))
    (when action
      (eglot--dcase action
        (((Command) command arguments)
         (eglot-execute-command server (intern command) arguments))
        (((CodeAction) edit command)
         (when edit (eglot--apply-workspace-edit edit))
         (when command
           (eglot--dbind ((Command) command arguments) command
             (eglot-execute-command server (intern command) arguments)))))))
  (save-current-buffer))



(provide 'conf-tags)
