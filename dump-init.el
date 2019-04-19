(setq vmacs-dumping-state 'dumping)
(load (concat (file-name-directory load-file-name) "init.el"))
(require 'saveplace)
(require 'savehist)
(require 'dired)
(require 'dired-x)
(require 'dired-aux)
(require 'wdired)

(require 'elec-pair)
(require 'recentf)

(require 'ido)
(require 'ibuffer)
(require 'ibuf-ext)
(require 'ibuf-macs)
(require 'helm)
(require 'hippie-exp)
(require 'ffap)
(require 'filecache)
(require 'epa)
(require 'autoinsert)
(require 'ansi-color)



(require 'diff-mode)
(require 'log-edit)
(require 'log-view)
(require 'tramp)
(require 'thingatpt)
(require 'frame)
(require 'uniquify)
(require 'scroll-bar)

(require 'abbrev)
(require 'align)
;; (require 'eshell)
;; (require 'em-term)
(require 'css-mode)
(require 'winner)
(require 'widget)
(require 'cc-mode)
(require 'flymake)
(require 'hideshow)
(require 'grep)
(require 'etags)
(require 'python)
(require 'which-func)
(require 'sh-script)
(require 'pcomplete)
(require 'outline)
(require 'json)
(require 'isearch)

(require 'vc)
(require 'vc-git)
(require 'vc-svn)
(require 'vc-dir)
(require 'diff)
(require 'ediff)
(require 'ediff)
(require 'ediff-diff)
(require 'ediff-merg)
(require 'ediff-vers)
(require 'ediff-wind)
(require 'em-tramp)
(require 'org)
(require 'org-agenda)

(require 'git-timemachine)
(require 'json-mode)
(require 'iedit)
(require 'go-imports)
;; (require 'sane-term)
;; (require 'shell-toggle)
(require 'ctable)
(require 'dash)
(require 'deferred)
(require 'osx-dictionary)
(require 'dired-narrow)
(require 'smex)
(require 'ivy-dired-history)
(require 'counsel)
(require 'flx)
(require 'gitconfig-mode)
(require 'dired-filetype-face)
(require 'auto-compile)
(require 'golden-ratio-scroll-screen)
(require 'exec-path-from-shell)
(require 'bm)

;; (require 'crontab-mode)
(require 'dockerfile-mode)
(require 'erlang)
(require 'ethan-wspace)
(require 'flycheck)
(require 'git-commit)
(require 'go-mode)
;; (require 'go-eldoc)
(require 'golden-ratio)
(require 'goto-chg)

(require 'thrift)
(require 'wgrep)
(require 'with-editor)
(require 'yasnippet)
(require 'async)
(require 'evil)
(require 'bind-map)
(require 'evil-textobj-anyblock)
(require 'company)
(require' company-abbrev)
(require 'company-bbdb)
(require 'company-capf)
(require 'company-clang)
(require 'company-cmake)
(require 'company-css)
(require 'company-dabbrev-code)
(require 'company-dabbrev)
(require 'company-eclim)
(require 'company-elisp)
(require 'company-etags)
(require 'company-files)
(require 'company-gtags)
(require 'company-ispell)
(require 'company-keywords)
(require 'company-nxml)
(require 'company-oddmuse)
(require 'company-semantic)
(require 'company-template)
(require 'company-tempo)
(require 'company-tng)
(require 'company-xcode)
(require 'company-yasnippet)
(require 'company-jedi)
;; (require 'eglot)
(require 'company-go)


(require 'lazy-evil)
(require 'lazy-command)
(require 'compile-dwim)
(require 'helm-gtags)
(require 'lazy-buffer)
(require 'lazy-camelize)
(require 'lazy-dired-sort)
(require 'lazy-dired)
(require 'lazy-font)
(require 'lazy-golang)
(require 'lazy-goto-definition)
(require 'lazy-helm)
(require 'lazy-ivy)
(require 'lazy-json)
(require 'lazy-minibuffer)
(require 'lazy-novel-mode)
(require 'lazy-open-in-file-manager)
(require 'lazy-org)
(require 'lazy-program-objc)
(require 'lazy-program-protobuf)
(require 'lazy-smart-tab)
(require 'lazy-sudo)
;; (require 'lazy-term)
(require 'lazy-toggle-eshell)
(require 'lazy-window)
(require 'vmacs-dired-single)
(require 'vmacs-switch-buffer)
;; (require 'mysql-query)
(require 'sqlparser-mysql-complete)


(when (vmacs-dumping-p)
  ;; disable undo-tree to prevent from segfaulting when loading the dump
  (message "dumping vmacs")
  (global-undo-tree-mode -1)
  (setq load-path-backup load-path)
  (setq vmacs-dumping-state 'dumped)
  (garbage-collect))


;; ;; (require 'applescript-mode)





(provide 'dump-init)

;; Local Variables:
;; coding: utf-8
;; End:

;;; .emacs.d/dump-init.el ends here.
