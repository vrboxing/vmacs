;; 如果配置好了， 下面20个汉字与40个英文字母应该等长
;;  这个工具不错 https://blindwith.science/2019/07/443.html/
;; here are 20 hanzi and 40 english chars, see if they are the same width
;;
;; Sarasa Mono CL-18 等高等宽字体  更纱黑体
;; https://ericzhuochen.com/blog/post/emacs-1-font/
;; https://github.com/be5invis/Sarasa-Gothic
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

;; https://protesilaos.com/modus-themes/#h:f4651d55-8c07-46aa-b52b-bed1e53463bb
(setq modus-vivendi-theme-override-colors-alist
      '(("bg-tab-active" . "gray45")))

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
(provide 'conf-face)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-face.el ends here.
