;; C-x esc esc 可以查看global-set-key 究竟bind哪个key
;; 默认Emacs 把TAB==`C-i'
;;            RET==`C-m'
;;            ESC==`C-['
;;这样可以进行绑定的键好像少了一些,
;;下面的方法可以实现将`C-i' `C-m'绑定与`TAB' `RET'不同的func
;; (defun vmacs-translate-keybind(&optional f) ;
;;   (with-selected-frame (or f (selected-frame))
;;     (when (display-graphic-p)
;;       (define-key input-decode-map [?\C-i] [C-i]) ;(global-set-key (kbd "<C-i>") 'counsel-git)
;;       (define-key input-decode-map [?\C-m] [C-m]) ; (global-set-key (kbd "<C-m>") 'counsel-git)
;;       )))

;; (add-hook 'after-make-frame-functions 'vmacs-translate-keybind)
;; (add-hook 'after-init-hook 'vmacs-translate-keybind) ;this is need for windows
;; (require 'bind-map)

;; (defun vmacs--leader-map-init-map(mode map &optional minor states)
;;   (let ((prefix (intern (format "%s-prefix" map))))
;;     (or (boundp prefix)
;;         (progn
;;           (eval
;;            `(progn
;;               (bind-map ,map
;;                 :prefix-cmd ,prefix
;;                 ,(if minor :minor-modes :major-modes) (,mode)
;;                 :keys ("M-m")
;;                 ;; :override-minor-modes t
;;                 :evil-keys ("SPC")
;;                 :evil-states ,(if states states '(normal motion visual evilified)))
;;               ;; 默认会继承vmacs-leader-map 的全局设置
;;               (set-keymap-parent ,map vmacs-leader-map)))
;;           (boundp prefix)))))

;; (bind-map vmacs-leader-map
;;   :keys ("M-m")
;;   :evil-keys ("SPC")
;;   ;; :override-minor-modes t
;;   :evil-states (normal motion visual))



;; ;; (macroexpand '(evil-define-key '(normal visual operator motion emacs) 'global (kbd "<SPC>b") 'forward-char))
;; ;; (bind-map-set-keys vmacs-leader-map "b" 'forward-char)
;; (defmacro vmacs-leader(key def &rest bindings)
;;   `(bind-map-set-keys  vmacs-leader-map ,key ,def ,@bindings))


;; 这种方式会使用vmacs-leader-map 的keys等属性，但:bindings并不会继承
;; 即便此处没有:bingding也一样
;; (bind-map-for-mode-inherit my-markdown-map vmacs-leader-map
;;   :major-modes (markdown-mode)
;;   :bindings ("c" 'forward-button))

;; ;; 几种用法举例
;; ;; 默认dired spc有绑定按键，却space不会做为leader key
;; ;; vmacs-leader-for-major-mode 会为dired-mode 启用leader key
;; ;; (vmacs-leader-for-major-mode 'dired-mode )
;; ;; (vmacs-leader-for-major-mode '(dired-mode message-mode))
;; ;; 除了继承默认的leader外，dired 中特殊绑定 "b" 按键
;; ;; (vmacs-leader-for-major-mode 'dired-mode "b" 'forward-char)
;; (defmacro vmacs-leader-for-major-mode (major-modes  &rest bindings)
;;   "enable leader key  for the major-mode
;; MODES. MODES should be a quoted symbol or a list of symbol  corresponding to a valid
;; major mode. The rest of the arguments are treated exactly like
;; they are in `bind-map-set-keys'."
;;   `(vmacs-leader-for ,major-modes nil ,@bindings))



;; ;; 几种用法举例
;; ;; insert 模式下为特定的major-mode启动leader
;; ;; states 可以为nil 表示使用默认值'(normal motion visual evilified)
;; (defun vmacs-leader-for (major-modes &optional states  &rest bindings)
;;   "enable leader key  for the major-mode
;; MODES. MODES should be a quoted symbol or a list of symbol  corresponding to a valid
;; major mode. The rest of the arguments are treated exactly like
;; they are in `bind-map-set-keys'."
;;   (let ((major-modes (if (listp major-modes ) major-modes (list major-modes))))
;;     (dolist (mode major-modes)
;;       (let ((map (intern (format "vmacs-%s-map" mode)))
;;             (key  (pop bindings)) def)
;;         (when (vmacs--leader-map-init-map mode map nil states)
;;           (while key
;;             (setq def (pop bindings))
;;             (define-key (symbol-value map) (kbd key) def)
;;             (setq key (pop bindings) )))))))


;; ;; 目前未验证是否可用
;; ;; state 可以为nil 表示normal 模式
;; ;; (vmacs-leader-for-minor-mode '(mode1) '(insert) "b" 'forward-cahr)
;; ;; (vmacs-leader-for-minor-mode '(mode1) nil "b" 'forward-cahr)
;; ;; (vmacs-leader-for-minor-mode '(mode1) nil )
;; ;; (vmacs-leader-for-minor-mode '(mode1)  )
;; ;; (vmacs-leader-for-minor-mode mode1 nil )
;; ;; (vmacs-leader-for-minor-mode mode1  )
;; (defun vmacs-leader-for-minor-mode(minor-modes &optional states  &rest bindings)
;;   "enable leader key  for the minor-mode
;; MODES. MODES should be a quoted symbol or a list of symbol  corresponding to a valid
;; minor mode. The rest of the arguments are treated exactly like
;; they are in `bind-map-set-keys'."
;;   (let ((minor-modes (if (listp minor-modes ) minor-modes (list minor-modes))))
;;     (dolist (mode minor-modes)
;;       (let ((map (intern (format "vmacs-%s-map" mode)))
;;             (key  (pop bindings)) def)
;;         (when (vmacs--leader-map-init-map mode map t states)
;;           (while key
;;             (setq def (pop bindings))
;;             (define-key (symbol-value map) (kbd key) def)
;;             (setq key (pop bindings) )))))))

;; iterm2下实同一些 终端下本没有的按键
;;参见 这个链接中含中文  http://jixiuf.github.io/blog/emacs-在mac上的安装及一些相应配置/#orgheadline15
;; (defun iterm2-keybind-mapping()
;;   (global-set-key (kbd "C-[ [ 1 a") (key-binding(kbd "C-<backspace>"))) ;== "M-[ a a" iterm2 map to ctrl-backspace
;;   ;; (global-set-key (kbd "C-[ [ 1 c") 'hippie-expand)   ; iterm map to ctrl-return
;;   (global-set-key (kbd "C-[ [ 1 d") (key-binding (kbd "C-,") ))   ;iterm2 map to ctrl-,

;;   (global-set-key (kbd "C-[ [ 1 e") (key-binding (kbd "C-.") ))   ;iterm2 map to ctrl-.
;;   (global-set-key (kbd "C-[ [ 1 f") (key-binding (kbd "C-;") ))   ; iterm map to ctrl-;
;;   ;; (global-set-key (kbd "C-[ [ 1 h") (key-binding (kbd "C-i") )) ; iterm map to C-i
;;   (global-set-key  (kbd "C-[ [ 1 h") (key-binding (kbd "<C-i>") )) ;iterm map to C-i
;;   (global-set-key (kbd "C-[ [ 1 i") (key-binding (kbd "C-3") ))   ;iterm2 map to ctrl-3
;;   (global-set-key (kbd "C-[ [ 1 j") 'ignore) ; iterm map to C-4
;;   (global-set-key (kbd "C-[ [ 1 j") (key-binding (kbd "C-4") ))   ;iterm2 map to ctrl-f3
;;   (global-set-key (kbd "C-[ [ 1 m") (key-binding (kbd "<C-m>") ))   ;iterm2 map to C-m
;;   ;; (global-set-key (kbd "C-w C-[ [ 1 h") 'goto-definition) ; C-wC-i

;;   (global-set-key (kbd "C-[ [ 1 l") (key-binding (kbd "C-<f3>") ))   ;iterm2 map to ctrl-f3

;;   (global-set-key (kbd "C-[ [ 1 b") (key-binding (kbd "C-<f2>") )) ; map to ctrl-f2
;;   ) ;iterm2特有的配置
;; ;; (iterm2-keybind-mapping)
;; (add-hook 'after-init-hook 'iterm2-keybind-mapping)
 ;iterm2特有的配置

;; (global-set-key (kbd "C-<f3>") 'vmacs-shell-toggle-cd)
;; (global-set-key (kbd "<f3>") 'vmacs-shell-toggle)
;; (global-set-key (kbd "C-<f3>") 'vmacs-eshell-term-toggle)
;; (global-set-key  (kbd "s-C-M-d") 'vmacs-shell-toggle)
;; (global-set-key [f3] 'cd-iterm2)
;;;###autoload
(defmacro define-key-lazy (mode-map key cmd  feature &optional state)
  "define-key in `eval-after-load' block. `feature' is the file name where defined `mode-map'"
  (if state
      `(eval-after-load ,feature '(evil-define-key ,state ,mode-map ,key ,cmd))
    `(eval-after-load ,feature '(define-key ,mode-map ,key ,cmd))))

;; (defmacro vmacs-leader-for-map (map feature)
;;   `(define-key-lazy ,map ,(kbd "SPC") nil ,feature ))


;; (global-set-key [f2] 'vterm-toggle)
;; (global-set-key [C-f2] 'vterm-toggle-cd)
(global-set-key (kbd "s-,") 'vterm-toggle)
;; (global-set-key (kbd "s-d") 'vterm-toggle)
;; (global-set-key (kbd "s-C-M-d") 'vterm-toggle)
(global-set-key  (kbd "s-t") 'vterm-toggle-cd)
(define-key special-mode-map " " nil)

(global-set-key [(tab)]       'smart-tab)
(global-set-key (kbd "TAB")   'smart-tab)
;; (global-set-key (kbd "<C-i>") 'counsel-git) ;Ctrl-i not tab
(global-set-key (kbd "C-9")   #'(lambda() (interactive)(insert "()")(backward-char 1)))
(global-set-key (kbd "C-0")   #'(lambda() (interactive)(insert ")")))
(global-set-key (kbd "C--")   #'(lambda() (interactive)(insert "_")))
(defun vmacs-isearch-insert_()
  (interactive)
  (isearch-printing-char ?_))
(define-key isearch-mode-map  (kbd "C--")   'vmacs-isearch-insert_)
(defun vmacs-isearch-insert-quote()
  (interactive)
  (isearch-printing-char ?\"))

(define-key isearch-mode-map  (kbd "C-'")   'vmacs-isearch-insert-quote)
(global-set-key (kbd "C-'")   #'(lambda() (interactive)(insert "\"\"")(backward-char 1)))

(global-set-key (kbd "C-7")   #'(lambda() (interactive)(insert "&")))
(global-set-key (kbd "C-8")   #'(lambda() (interactive)(insert "*")))
(defun vmacs-isearch-insert-shift1()
  (interactive)
  (isearch-printing-char ?\!))
(global-set-key (kbd "C-1")   #'(lambda() (interactive)(insert "!")))
(define-key isearch-mode-map  (kbd "C-1")   'vmacs-isearch-insert-shift1)

(with-eval-after-load 'isearch (define-key isearch-mode-map [escape] 'isearch-abort))


(global-set-key (kbd "s-m") 'toggle-frame-maximized) ;cmd-m
(global-set-key  (kbd "s-a") 'evil-mark-whole-buffer) ;mac Cmd+a
;; (global-set-key  (kbd "s-t") 'shell-toggle-cd) ;mac Cmd+a

(global-set-key  (kbd "s-s") 'evil-write-all)

(global-set-key  (kbd "s-z") 'undo)
(global-set-key  (kbd "s-r") 'compile-dwim-compile)

(global-set-key  (kbd "s-l") 'delete-other-windows)
(global-set-key  (kbd "s-o") 'other-window)
(global-set-key  (kbd "s-C-M-o") 'other-window)

(global-set-key  [C-M-s-268632079] 'other-window)

;; (global-set-key  (kbd "s-n") 'vmacs-split-window-or-other-window)
;; (global-set-key  (kbd "s-C-M-n") 'vmacs-split-window-or-other-window)
;; (global-set-key  (kbd "s-p") 'vmacs-split-window-or-prev-window)
;; (global-set-key  (kbd "s-C-M-p") 'vmacs-split-window-or-prev-window)


(global-set-key [C-M-s-return] 'vmacs-window-rotate)




(global-set-key  (kbd "C-,") 'scroll-other-window-down)
(global-set-key  (kbd "C-.") 'scroll-other-window)
(global-set-key  (kbd "C-\\") 'hippie-expand)

;; (global-set-key  (kbd "s-q") 'delete-frame)
;; (global-set-key  (kbd "s-C-S-M-q") 'delete-frame)
;; (global-set-key  (kbd "s-w") 'delete-window)
(global-set-key  (kbd "s-1") 'delete-other-windows)
(global-set-key  (kbd "s-C-M-1") 'delete-other-windows) ;hyper-1
(global-set-key  (kbd "s-C-M-2") 'vmacs-split-window-vertically) ;hyper-2
(global-set-key  (kbd "s-2") 'vmacs-split-window-vertically)
(global-set-key  (kbd "s-C-M-3") 'vmacs-split-window-horizontally) ;hyper-2
(global-set-key  (kbd "s-3") 'vmacs-split-window-horizontally)
(with-eval-after-load 'cus-edit (define-key custom-mode-map "n" nil))

(global-set-key (kbd "s-C-M-i")  'vmacs-git-files)

(autoload 'dap-debug "dap-mode" nil t)
(global-set-key (kbd "<f6>")  'dap-debug)





(provide 'conf-keybind)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-iterm2.el ends here.
