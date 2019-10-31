;; 如果配置好了， 下面20个汉字与40个英文字母应该等长
;;  这个工具不错 https://blindwith.science/2019/07/443.html/
;; here are 20 hanzi and 40 english chars, see if they are the same width
;;
;; ;; 1l0oOLiI
;; aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa|
;; 你你你你你你你你你你你你你你你你你你你你|
;; ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,|
;; 。。。。。。。。。。。。。。。。。。。。|
;; 1111111111111111111111111111111111111111|
;; 東東東東東東東東東東東東東東東東東東東東|
;; ここここここここここここここここここここ|
;; ｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺｺ|
;; 까까까까까까까까까까까까까까까까까까까까|

;; (create-frame-font-middle-mac)
;; (create-fontset-from-fontset-spec
;;    "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-fontset-mymac,
;;  ascii:-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1,
;; han:-*-PingFang SC-normal-normal-normal-*-14-*-*-*-p-0-iso10646-1,
;; cjk-misc:-*-PingFang SC-normal-normal-normal-*-14-*-*-*-p-0-iso10646-1,
;; kana:-*-PingFang SC-normal-normal-normal-*-14-*-*-*-p-0-iso10646-1,
;; hangul:-*-Apple SD Gothic Neo-normal-normal-normal-*-16-*-*-*-p-0-iso10646-1")
;; (add-to-list 'default-frame-alist '(font . "fontset-mymac"))
;; (set-frame-font "fontset-mymac" )

(defface font-lock-todo-face nil
  "Font Lock mode face used to highlight TODO."
  :group 'font-lock-faces)
(defface font-lock-done-face nil
  "Font Lock mode face used to highlight DONE."

  :group 'font-lock-faces)
(dolist (mode '(c-mode c++-mode java-mode lisp-mode emacs-lisp-mode erlang-mode
                       go-mode
                       actionscript-mode lisp-interaction-mode sh-mode sgml-mode))
  (font-lock-add-keywords
   mode
   '(("\\<\\(FIXME\\|TODO\\|Todo\\|HACK\\|todo\\):" 1  'font-lock-todo-face prepend)
     ("@\\<\\(FIXME\\|TODO\\|Todo\\|HACK\\|todo\\)" 1  'font-lock-todo-face prepend)
     ("\\<\\(DONE\\|Done\\|done\\):" 1 'font-lock-done-face t)
     ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face)
     )))

;; show some functions as keywords
(font-lock-add-keywords 'emacs-lisp-mode
                        '(("\\<\\(quote\\|add-hook\\|equal\\)" .
                           font-lock-keyword-face)))

(add-to-list 'default-frame-alist '(ns-appearance . dark))
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(defun  emacs-daemon-after-make-frame-hook(&optional f) ;emacsclient 打开的窗口相关的设置
  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  ;; (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  (with-selected-frame f
    ;;(kill-buffer "*scratch*" )
    (if (window-system)
        (ivy-posframe-mode 1)
      (ivy-posframe-mode -1))

    (when (window-system)
      ;; (when (equal system-type 'darwin) (create-frame-font-mac))
      ;; (when (equal system-type 'windows-nt) (create-frame-font-w32))
      (window-divider-mode t)
      (set-frame-position f 40 45)
      (set-frame-size f 138 43)
      (set-frame-parameter f 'alpha 85)
      ;; (set-frame-parameter f 'foreground-color "#eeeeec")
      (set-frame-parameter f 'font "Ubuntu Mono-16")
      (set-frame-parameter f 'background-mode 'dark)
      (raise-frame))))

(add-hook 'after-make-frame-functions 'emacs-daemon-after-make-frame-hook)
;; emacs-daemon-after-make-frame-hook

(when  (and (not (daemonp))
            (vmacs-not-dumping-p))
  (setq-default window-system-default-frame-alist ;直接emacs命令打开的窗口相关设置,不要在这里设置字体，否则daemon 启动时字体有可能没创建好，会导致字体设置失败
                '( (x ;; if frame created on x display
                    (alpha . 80)
                    (cursor-color . "green")
                    )
                   (mac ;; mac-port emacs
                    (alpha . 85)
                    (height . 43)
                    (width . 140)
                    (left . 160)
                    (top . 80)
                    ;; (foreground-color . "#eeeeec")
                    ;; (background-color . "#202020") ;;
                    (font . "Ubuntu Mono-16")
                    (background-mode . dark)
                    )
                   (ns ;; if frame created on mac
                    ;; (height . 50)
                    ;; (width . 140)
                    ;; (left . 160)
                    ;; (top . 80)
                    (alpha . 85)
                    (font . "Ubuntu Mono-16")
                    ;; (foreground-color . "#eeeeec")
                    ;; (background-color . "#202020") ;;
                    (background-mode . dark)
                    )
                   (w32
                    (foreground-color . "#eeeeec")
                    (background-color . "#202020") ;;
                    (background-mode . dark)
                    (alpha . 95)
                    (cursor-color . "green")
                    (height . 30)
                    (width . 100)
                    (left . 200)
                    (top . 20)
                    )
                   (nil ;; if on term
                    (background-mode . dark)
                    ))))
;;
;; (setq-default undo-tree-mode-lighter " Ü") ;undo
;; (setq-default helm-completion-mode-string " H")

;; (setq-default mode-line-cleaner-alist
;;               `((auto-complete-mode . " á")
;;                 (company-mode . "")
;;                 (yas-minor-mode . "")
;;                 (undo-tree-mode . "")
;;                 (golden-ratio-mode . "")
;;                 (flymake-mode . " Fly")
;;                 (ivy-mode . "")
;;                 ;; major mode
;;                 (dired-mode . " Dired")
;;                 (fundamental-mode . "Fd")
;;                 (ibuffer-mode . "iBuf")
;;                 (python-mode . "Py")
;;                 (lisp-interaction-mode . "iEL")
;;                 (emacs-lisp-mode . "EL")))

;; (defun clean-mode-line ()
;;   (interactive)
;;   (dolist (cleaner mode-line-cleaner-alist)
;;     (let* ((mode (car cleaner))
;;            (mode-str (cdr cleaner))
;;            (old-mode-str (cdr (assq mode minor-mode-alist))))
;;       (when old-mode-str
;;         (setcar old-mode-str mode-str))
;;       ;; major mode
;;       (when (eq mode major-mode)
;;         (setq mode-name mode-str)))))

;; (add-hook 'after-change-major-mode-hook 'clean-mode-line)
;; ;; 然后将mode-line 的face header调成0.1，变成一条线
(setq-default mode-line-format nil)
(setq mode-line-format nil)




(provide 'conf-face)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-face.el ends here.
