(provide 'custom-file)
;;下面的值是通过Emacs的custom 系统关于外观的设置,如无必要不要手动修改

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#616161" "#ff8272" "#b4fa72" "#fefdc2" "#a5d5fe" "#ff8ffd" "#d0d1fe" "#f1f1f1"])
 '(auto-save-visited-interval 30)
 '(auto-save-visited-mode t)
 '(backup-directory-alist '((".*" . "~/.emacs.d/cache/backup_files/")))
 '(blink-cursor-mode t)
 '(bookmark-default-file "~/.emacs.d/cache/bookmarks")
 '(centaur-tab-background-color "#202020")
 '(column-number-mode nil)
 '(custom-group-tag-faces '(default))
 '(custom-safe-themes
   '("4eb91832611e5f6425993acc79f38e51fbb7ae616ad43711a4896bfd3cc11dcd" "4cd18f0ee92079a3edf5d87e7ad4d17c69dde4e36ecf6ea13f011dd65f239c30" "c22c3795ab46e04c156c860e76c1b5ad826be8a5ef7f0bf17db19f7643d44a0a"))
 '(display-fill-column-indicator t)
 '(electric-pair-mode t)
 '(flycheck-check-syntax-automatically '(save mode-enabled))
 '(flycheck-idle-change-delay 1)
 '(global-auto-revert-mode t)
 '(helm-minibuffer-history-key "C-r")
 '(ivy-posframe-border-width 10)
 '(lsp-auto-guess-root t)
 '(lsp-enable-symbol-highlighting nil)
 '(lsp-restart 'auto-restart)
 '(magit-commit-ask-to-stage t)
 '(magit-no-confirm
   '(reverse rename abort-merge resect-bisect kill-process stage-all-changes unstage-all-changes))
 '(magit-save-repository-buffers 'dontask)
 '(menu-bar-mode nil)
 '(org-agenda-files nil)
 '(package-selected-packages
   '(clang-format centaur-tabs 0blayout ivy-posframe lsp-python-ms pyim ccls magit-libgit org-re-reveal htmlize evil-magit git-link lv evil company-lsp bind-map elisp-def company-go company-posframe dockerfile-mode json-mode iedit go-imports osx-dictionary dired-narrow smex ivy-dired-history counsel flx magit gitconfig-mode dired-filetype-face auto-compile golden-ratio-scroll-screen company evil-textobj-anyblock exec-path-from-shell applescript-mode bm ethan-wspace git-commit go-mode golden-ratio goto-chg logstash-conf lua-mode markdown-mode protobuf-mode thrift web-mode wgrep with-editor yaml-mode yasnippet))
 '(recentf-save-file "~/.emacs.d/cache/recentf")
 '(safe-local-variable-values
   '((git-commit-major-mode . git-commit-elisp-text-mode)
     (projectile-project-run-cmd . "mkdir -p build; cd build; cmake ..; make run")
     (projectile-project-compilation-cmd . "mkdir -p build; cd build; cmake ..; make")
     (projectile-project-compilation-cmd . "bear make")
     (projectile-project-run-cmd . "make run")
     (eval when
	   (and
	    (buffer-file-name)
	    (file-regular-p
	     (buffer-file-name))
	    (string-match-p "^[^.]"
			    (buffer-file-name)))
	   (unless
	       (featurep 'package-build)
	     (let
		 ((load-path
		   (cons "../package-build" load-path)))
	       (require 'package-build)))
	   (package-build-minor-mode)
	   (set
	    (make-local-variable 'package-build-working-dir)
	    (expand-file-name "../working/"))
	   (set
	    (make-local-variable 'package-build-archive-dir)
	    (expand-file-name "../packages/"))
	   (set
	    (make-local-variable 'package-build-recipes-dir)
	    default-directory))
     (eval progn
	   (setq jedi:environment-root
		 (expand-file-name "./virtual/"
				   (locate-dominating-file default-directory "Makefile")))
	   (setq jedi:server-args
		 `("--virtual-env" ,(expand-file-name "./virtual/"
						      (locate-dominating-file default-directory "Makefile"))
		   "--virtual-env" ,(expand-file-name "~/python/")
		   "--virtual-env" "/System/Library/Frameworks/Python.framework/Versions/2.7/" "--sys-path" ,(expand-file-name
													      (expand-file-name "./src/"
																(locate-dominating-file default-directory "Makefile")))
		   "--sys-path" ,(expand-file-name
				  (expand-file-name "./src/db"
						    (locate-dominating-file default-directory "Makefile")))
		   "--sys-path" "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7" "--sys-path" "."))
	   (setq exec-path
		 (delete-dups
		  (cons
		   (expand-file-name "./virtual/bin/"
				     (locate-dominating-file default-directory "Makefile"))
		   exec-path)))
	   (setenv "PATH"
		   (concat
		    (expand-file-name "./virtual/bin/"
				      (locate-dominating-file default-directory "Makefile"))
		    ":"
		    (getenv "PATH")))
	   (setenv "PYTHONPATH"
		   (expand-file-name "./src/"
				     (locate-dominating-file default-directory "Makefile")))
	   (setenv "PYTHONPATH"
		   (expand-file-name "./db/"
				     (locate-dominating-file default-directory "Makefile"))))))
 '(save-place-file "~/.emacs.d/cache/place")
 '(savehist-file "~/.emacs.d/cache/history")
 '(scroll-bar-mode nil)
 '(tramp-persistency-file-name "~/.emacs.d/cache/tramp")
 '(tramp-syntax 'default nil (tramp))
 '(transient-history-file "~/.emacs.d/cache/transient/history.el")
 '(transient-levels-file "~/.emacs.d/cache/transient/levels.el")
 '(transient-values-file "~/.emacs.d/cache/transient/values.el")
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(warning-suppress-types '((yasnippet backquote-change)))
 '(window-divider-default-bottom-width 1)
 '(window-divider-default-places 'bottom-only)
 '(window-divider-default-right-width 1)
 '(window-divider-mode t)
 '(xref-after-jump-hook '(recenter)))
