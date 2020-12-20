;; https://github.com/mbriggs/.emacs.d/blob/master/my-keymaps.el

;; http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
;; https://github.com/cofi/dotfiles/blob/master/emacs.d/config/cofi-evil.el
;; https://github.com/syl20bnr/dotemacs/blob/master/init-package/init-evil.el
;;

;; 如果不想让某些命令jump ,则可以通过这种方式实现
;; You can disable it for %, f, F, t and T with the following:
;; (evil-set-command-property #'evil-jump-item :jump nil)
;; (evil-set-command-property #'evil-find-char :jump nil)
;; (evil-set-command-property #'evil-find-char-backward :jump nil)
;; (evil-set-command-property #'evil-find-char-to :jump nil)
;; (evil-set-command-property #'evil-find-char-to-backward :jump nil)



(require 'evil)
;; minor-mode
;; 设置一些mode的初始state
(add-hook 'org-capture-mode-hook 'evil-insert-state)
;; 设置一些mode的初始state
(evil-set-initial-state 'vterm-mode 'insert)
(evil-set-initial-state 'diff-mode 'normal)
(evil-set-initial-state 'git-rebase-mode 'normal)
(evil-set-initial-state 'package-menu-mode 'normal)
(evil-set-initial-state 'vc-annotate-mode 'normal)
(evil-set-initial-state 'Custom-mode 'normal)
(evil-set-initial-state 'erc-mode 'normal)
(evil-set-initial-state 'ibuffer-mode 'normal)
(evil-set-initial-state 'vc-dir-mode 'normal)
(evil-set-initial-state 'vc-git-log-view-mode 'normal)
(evil-set-initial-state 'log-edit-mode 'insert)
(evil-set-initial-state 'vc-svn-log-view-mode 'normal)
;; (evil-set-initial-state 'erlang-shell-mode 'normal)
(evil-set-initial-state 'org-agenda-mode 'normal)
(evil-set-initial-state 'minibuffer-inactive-mode 'insert)
(evil-set-initial-state 'ivy-occur-mode 'normal)
(evil-set-initial-state 'ivy-occur-grep-mode 'normal)
(evil-set-initial-state 'grep-mode 'normal)
(evil-set-initial-state 'Info-mode 'motion)
(evil-set-initial-state 'calc-mode 'normal)
(evil-set-initial-state 'snails-mode 'insert)
(evil-set-initial-state 'rg-mode 'normal)
(evil-set-initial-state 'help-mode 'normal)

;; (evil-set-initial-state 'term-mode 'normal)
;; (evil-set-initial-state 'eshell-mode 'normal)

;; 把所有emacs state  的mode 都转成insert mode
(dolist (mode evil-emacs-state-modes)
  (cond
   ((memq mode evil-normal-state-modes)
    (evil-set-initial-state mode 'normal))
   ((memq mode evil-motion-state-modes)
    (evil-set-initial-state mode 'motion))
   (t
    (evil-set-initial-state mode 'insert))))

(setq evil-emacs-state-modes nil)


;; evil-overriding-maps中的按键绑定 优先级高于evil-mode
(add-to-list 'evil-overriding-maps '(vc-git-log-view-mode-map . nil))
(add-to-list 'evil-overriding-maps '(vc-svn-log-view-mode-map . nil))
;; (add-to-list 'evil-overriding-maps '(vmacs-leader-map . nil))
(add-to-list 'evil-overriding-maps '(custom-mode-map . nil))
(add-to-list 'evil-overriding-maps '(ediff-mode-map . nil))
(add-to-list 'evil-overriding-maps '(package-menu-mode-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-completion-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-inactive-mode-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-must-match-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-isearch-map . nil))
(add-to-list 'evil-overriding-maps '(minibuffer-local-ns-map . nil))
(add-to-list 'evil-overriding-maps '(epa-key-list-mode-map . nil))
(add-to-list 'evil-overriding-maps '(term-mode-map . nil))
(add-to-list 'evil-overriding-maps '(term-raw-map . nil))
(add-to-list 'evil-overriding-maps '(calc-mode-map . nil))
(add-to-list 'evil-overriding-maps '(rg-mode-map . nil))
(add-to-list 'evil-overriding-maps '(magit-blob-mode-map . nil)) ;n p 浏览文件历史版本
(add-to-list 'evil-overriding-maps '(org-agenda-mode-map . nil))
(add-to-list 'evil-overriding-maps '(xref--xref-buffer-mode-map . nil))
(add-to-list 'evil-overriding-maps '(snails-mode-map . nil))
(add-to-list 'evil-overriding-maps '(embark-occur-mode-map . nil))
(add-to-list 'evil-overriding-maps '(tablist-minor-mode-map . nil))

(evil-set-custom-state-maps 'evil-overriding-maps
                            'evil-pending-overriding-maps
                            'override-state
                            'evil-make-overriding-map
                            evil-overriding-maps)

;; evil-normalize-keymaps forces an update of all Evil keymaps
(add-hook 'magit-blob-mode-hook #'evil-normalize-keymaps)
;; 更新 evil-overriding-maps ,因为org-agenda-mode-map 变量初始为空keymap,在org-agenda-mode内才往里添加绑定
(add-hook 'org-agenda-mode-hook #'evil-normalize-keymaps)



;; (setq display-line-numbers-current-absolute t)
(defun vmacs-change-line-number-abs()
  (if (member major-mode '( embark-occur-mode term-mode eshell-mode ansi-term-mode tsmterm-mode magit-status-mode ))
      (setq display-line-numbers nil)
    (setq display-line-numbers 'absolute)))

(defun vmacs-change-line-number-relative()
  (if (member major-mode '(embark-occur-mode vterm-mode term-mode eshell-mode ansi-term-mode tsmterm-mode magit-status-mode))
      (if (member major-mode '(vterm-mode))
          (setq display-line-numbers 'absolute)
          (setq display-line-numbers nil)
          )
    (setq display-line-numbers 'visual)))


(add-hook 'evil-insert-state-entry-hook 'vmacs-change-line-number-abs)
(add-hook 'evil-normal-state-entry-hook 'vmacs-change-line-number-relative)
(add-hook 'evil-motion-state-entry-hook 'vmacs-change-line-number-relative)

(evil-mode 1)

;; emacs 自带的repeat 绑定在C-xz上， 这个advice ,奖 repeat 的功能 与evil 里的","功能合
;; 2为1,一起绑定在","紧临evil-repeat"." 如此一来， 跟编辑相关的repeat用"." ,跟光标移动相关的
;; 可以用","
(defadvice repeat(around evil-repeat-find-char-reverse activate)
  "if last-command is `evil-find-char' or
`evil-repeat-find-char-reverse' or `evil-repeat-find-char'
call `evil-repeat-find-char-reverse' if not
execute emacs native `repeat' default binding to`C-xz'"
  (if (member last-command '(evil-find-char
                             evil-repeat-find-char-reverse
                             repeat
                             evil-find-char-backward
                             evil-repeat-find-char))
      (progn
        ;; ;I do not know why need this(in this advice)
        (when (evil-visual-state-p)(unless (bobp) (forward-char -1)))
        (call-interactively 'evil-repeat-find-char-reverse)
        (setq this-command 'evil-repeat-find-char-reverse))
    ad-do-it))

;; ctrl-g 时，回到normal状态
(defadvice keyboard-quit (before evil-insert-to-nornal-state activate)
  "C-g back to normal state"
  (when  (evil-insert-state-p)
    (cond
     ((equal (evil-initial-state major-mode) 'normal)
      (evil-normal-state))
     ((equal (evil-initial-state major-mode) 'insert)
      (evil-normal-state))
     ((equal (evil-initial-state major-mode) 'motion)
      (evil-motion-state))
     ((equal (evil-initial-state-for-buffer-name (buffer-name) 'insert) 'insert)
      (evil-normal-state))
     ((equal (evil-initial-state-for-buffer-name (buffer-name) 'insert) 'motion)
      (evil-motion-state))
     (t
      (if (equal last-command 'keyboard-quit)
          (evil-normal-state)           ;如果初始化state不是normal ，按两次才允许转到normal state
        (evil-change-to-initial-state)) ;如果初始化state不是normal ，按一次 转到初始状态
      ))))

(with-eval-after-load 'org-agenda
  (evil-define-key 'normal org-agenda-mode-map
    "j" 'evil-next-line
    "k" 'evil-previous-line
    ":" 'evil-ex
    "r" 'org-agenda-redo))

;; ;; 清空所有insert-state的绑定,这样 ,insert mode 就是没装evil 前的正常emacs了
;; (setcdr evil-insert-state-map nil);evil-disable-insert-state-bindings
(setq evil-window-map nil)
;; (define-key evil-insert-state-map [escape] nil) ;emacs karabiner shift 输入法切换相关
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)

(define-key evil-ex-completion-map (kbd "M-p") 'previous-history-element) ;
(define-key evil-ex-completion-map (kbd "M-n")  'next-history-element)

;; (define-key evil-insert-state-map [escape] 'evil-normal-state)
;; (define-key evil-insert-state-map (kbd "C-g") 'vmacs-evil-normal-state)
;; (define-key evil-insert-state-map [escape] 'vmacs-evil-normal-state)

;; (define-key evil-normal-state-map "/" 'helm-swoop)

;; (define-key evil-motion-state-map "/" 'evil-search-forward)
;; (define-key evil-normal-state-map "/" 'evil-search-forward)



;; (define-key evil-window-map "1" 'delete-other-windows)
;; (define-key evil-window-map "0" 'delete-window)
;; (define-key evil-window-map "2" 'vmacs-split-window-vertically)
;; (define-key evil-window-map "3" 'vmacs-split-window-horizontally)

;; (define-key evil-normal-state-map (kbd "f") 'ace-jump-mode)
(define-key evil-normal-state-map (kbd "C-z") nil)
;; (define-key evil-normal-state-map (kbd "C-w") 'ctl-w-map)
(define-key evil-normal-state-map "\C-n" nil)
(define-key evil-normal-state-map "\C-p" nil)
(define-key evil-normal-state-map "\C-v" nil)
(define-key evil-motion-state-map "\C-v" nil)
(define-key evil-normal-state-map "\C-e" nil)

(evil-define-motion vmacs-evil-next-line (count)
  "Move the cursor COUNT lines down."
  :type line
  (let ((line-move-visual (not truncate-lines)))
    (evil-line-move (or count 1))))

(evil-define-motion vmacs-evil-previous-line (count)
  "Move the cursor COUNT lines up."
  :type line
  (let ((line-move-visual (not truncate-lines)))
    (evil-line-move (- (or count 1)))))


(fset 'evil-next-line 'vmacs-evil-next-line)
(fset 'evil-previous-line 'vmacs-evil-previous-line)
;; (define-key evil-motion-state-map "j" 'evil-next-visual-line)
;; (define-key evil-motion-state-map "k" 'evil-previous-visual-line)


;; (define-key evil-motion-state-map (kbd "C-w") nil)
(define-key evil-motion-state-map (kbd "C-i") nil)
(define-key evil-motion-state-map (kbd "C-b") nil)
(define-key evil-motion-state-map (kbd "C-d") nil)
(define-key evil-motion-state-map (kbd "C-e") nil)
(define-key evil-motion-state-map (kbd "C-f") nil)
(define-key evil-motion-state-map (kbd "C-y") nil)
(define-key evil-normal-state-map [remap yank-pop] nil)
(define-key evil-normal-state-map (kbd "M-.") nil)
(define-key evil-normal-state-map "q" nil)
(define-key evil-normal-state-map (kbd "DEL") nil) ;backupspace
(define-key evil-motion-state-map  (kbd "RET") nil) ;
(define-key evil-normal-state-map  (kbd "RET") nil) ;
(define-key evil-normal-state-map  (kbd "C-.") nil)
(define-key evil-normal-state-map  (kbd "M-.") nil)

(define-key evil-normal-state-map "m" nil)
(define-key evil-normal-state-map "mq" 'fill-paragraph)
(define-key evil-normal-state-map "mm" 'evil-set-marker) ;`


(define-key evil-normal-state-map (kbd "C-3") #'evil-search-word-backward) ;C-3
(define-key evil-normal-state-map (kbd "C-4") #'evil-search-word-forward) ;C-8
(define-key evil-normal-state-map (kbd "C-8") #'evil-search-word-forward) ;C-8


(define-key evil-normal-state-map "gh" 'evil-goto-line) ;default G

(define-key evil-normal-state-map "ga" (kbd "M-a"))
(define-key evil-normal-state-map "ge" (kbd "M-e"))
;; (define-key evil-normal-state-map "gA" (kbd "C-M-a"))
;; (define-key evil-normal-state-map "gE" (kbd "C-M-e"))

(define-key evil-normal-state-map "s" nil)
(define-key evil-normal-state-map "sa" 'evil-begin-of-defun)
(define-key evil-normal-state-map "sw" 'evil-begin-of-defun)

;; (define-key evil-normal-state-map "sp" 'evil-paste-pop)
;; (define-key evil-normal-state-map "sP" 'evil-paste-pop)


(define-key evil-normal-state-map "ss" 'evil-end-of-defun)
(define-key evil-normal-state-map "se" 'evil-end-of-defun)

(define-key evil-normal-state-map "me" 'evil-M-e)
(define-key evil-normal-state-map "ma" 'evil-M-a)

(define-key evil-normal-state-map "s/" 'goto-last-change)
(define-key evil-normal-state-map "s," 'goto-last-change-reverse)

;; (define-key evil-normal-state-map "eh" (kbd "C-M-h"))
(define-key evil-normal-state-map "sf" 'evil-C-M-f)
(define-key evil-normal-state-map "sb" 'evil-C-M-b)
(define-key evil-normal-state-map "sd" 'evil-C-M-k)
(define-key evil-normal-state-map "sy" 'evil-copy-sexp-at-point) ;kill-sexp,undo
(define-key evil-normal-state-map "sk" (kbd "C-k"))
(define-key evil-normal-state-map "su" (kbd "C-u 0 C-k")) ;H-i =C-u 删除从光标位置到行首的内容
(define-key evil-normal-state-map (kbd "C-j") 'open-line-or-new-line-dep-pos)
(define-key evil-normal-state-map "," 'repeat)
(define-key evil-visual-state-map "," 'repeat)
(define-key evil-motion-state-map "," 'repeat) ;

;; (define-key evil-ex-completion-map (kbd "H-m") 'exit-minibuffer)
(define-key evil-ex-completion-map (kbd "<C-m>") 'exit-minibuffer)

;; dib dab绑定
(define-key evil-inner-text-objects-map "b" 'evil-textobj-anyblock-inner-block)
(define-key evil-outer-text-objects-map "b" 'evil-textobj-anyblock-a-block)
(vmacs-leader (kbd "o") 'other-window)

(vmacs-leader (kbd "j") 'dired-jump)
(global-set-key  (kbd "s-j") 'dired-jump)


(vmacs-leader (kbd "l") 'ibuffer)

(evil-define-key 'normal 'global  (kbd "<SPC>C-g") 'keyboard-quit)
(vmacs-leader (kbd "zd") 'sdcv-to-buffer)

(vmacs-leader (kbd "s") 'evil-write-all)

;; (vmacs-leader (kbd "S") 'save-buffer)
;; (vmacs-leader (kbd "j") 'open-line-or-new-line-dep-pos)
(vmacs-leader (kbd "rt") 'string-rectangle)
(vmacs-leader (kbd "rk") 'kill-rectangle)
(vmacs-leader (kbd "ry") 'yank-rectangle)

(vmacs-leader (kbd "nw") 'widen)
(vmacs-leader (kbd "nn") 'narrow-to-region)

(vmacs-leader (kbd "xu") 'undo-tree-visualize)
(vmacs-leader (kbd "xv") 'switch-to-scratch-buffer)
(vmacs-leader (kbd "<RET>r") 'revert-buffer-with-coding-system) ;C-x<RET>r
(vmacs-leader (kbd "(") 'kmacro-start-macro) ;C-x(
(vmacs-leader (kbd ")") 'kmacro-end-macro) ;C-x
(vmacs-leader (kbd "ca") 'org-agenda)
(vmacs-leader (kbd "cc") 'toggle-case-fold)
(vmacs-leader (kbd "u") 'backward-up-list)
(vmacs-leader (kbd "t") 'org-agenda)
(vmacs-leader (kbd "$") 'toggle-truncate-lines)
(evil-define-key 'normal 'global  (kbd "<SPC>fo") 'ff-find-other-file) ;头文件与源文件间快速切换
(vmacs-leader (kbd "m") 'execute-extended-command)
(vmacs-leader (kbd "wl") 'git-link)
(vmacs-leader (kbd "wi") 'imenu)
(vmacs-leader (kbd "SPC") 'vmacs-switch-buffer)
(vmacs-leader (kbd "fh") #'(lambda()(interactive)(let ((default-directory "~/"))(call-interactively 'find-file))))
(vmacs-leader (kbd "ft") #'(lambda()(interactive)(let ((default-directory "/tmp/"))(call-interactively 'find-file))))

(setq ffap-machine-p-known 'accept)  ; no pinging
(vmacs-leader (kbd "ff") 'find-file-at-point)


(define-key evil-normal-state-map "\\" 'just-one-space-or-delete-horizontal-space)


(global-set-key (kbd "C-s") 'evil-search-forward)
(global-set-key (kbd "C-r") 'evil-search-backward)
(vmacs-leader (kbd "y") 'evil-paste-before) ;default P

;; 默认visual选中即复制到剪切版，去掉这个功能
(fset 'evil-visual-update-x-selection 'ignore)


;; (fset 'yank 'evil-paste-before)

(defadvice evil-ex-search (after dotemacs activate)
  ;; (recenter)
  (unless evil-ex-search-persistent-highlight
    (sit-for 0.1)
    (evil-ex-delete-hl 'evil-ex-search)))
;; (defadvice evil-ex-search-next (after dotemacs activate)
;;   (unless evil-ex-search-persistent-highlight
;;     (sit-for 0.1)
;;     (evil-ex-delete-hl 'evil-ex-search)))

;; (defadvice evil-ex-search-previous (after dotemacs activate)
;;   ;; (recenter)
;;   (unless evil-ex-search-persistent-highlight
;;   (sit-for 0.1)
;;   (evil-ex-delete-hl 'evil-ex-search)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (fset 'evil-visual-update-x-selection 'ignore)

(defadvice evil-write-all (after save-smart activate)
  (when (string-match-p "*Org Src" (buffer-name))
    (require 'org-src)
    (call-interactively 'org-edit-src-exit)))


(global-set-key (kbd "C-c C-c") 'vmacs-smart-double-ctrl-c)
(define-key evil-normal-state-map (kbd "M-o") 'toggle-camelize)
(define-key evil-motion-state-map (kbd "C-o") nil)

(evil-declare-motion 'golden-ratio-scroll-screen-down)
(evil-declare-motion 'golden-ratio-scroll-screen-up)

;; this is need for vterm
(autoload 'golden-ratio-scroll-screen-up "golden-ratio-scroll-screen" "" t)
(autoload 'golden-ratio-scroll-screen-down "golden-ratio-scroll-screen" "" t)
(define-key evil-motion-state-map (kbd "C-v") 'golden-ratio-scroll-screen-up)
(define-key evil-motion-state-map (kbd "M-v") 'golden-ratio-scroll-screen-down)
(define-key evil-motion-state-map (kbd "C-l") 'recenter-top-bottom)
(define-key evil-motion-state-map (kbd "C-k") 'vmacs-kill-region-or-line)


(global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up) ;C-v
;; (global-set-key "\C-u" 'gold-ratio-scroll-screen-up)
(global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down) ;M-v

;; 与选中区域有关的配置
;; 因为v 用于向后移动一个symbol的距离
(define-key evil-motion-state-map "sv" 'evil-visual-char) ;==v开始选中区域
(define-key evil-motion-state-map "sm" 'evil-visual-line) ;==V 开始行选中
;; 因为C-v用于滚屏，故mv==原vim的C-v
(define-key evil-normal-state-map "mv" 'evil-visual-block) ;==vim.C-v 开始矩形操作，然后移动位置，就可得到选区

(define-key evil-visual-state-map "n" 'rectangle-number-lines) ;C-xrN

(global-set-key  (kbd "C-2") 'set-mark-command)

;; 选中区域后 交换当前光标点，
(define-key evil-visual-state-map "x" 'exchange-point-and-mark)
(define-key evil-visual-state-map "X" 'evil-visual-exchange-corners)
;; 有一种需要是
;; 当我取消选中后 我希望光标停留在选中前光标所在的位置而不是在选区的开头或结尾处
(define-key evil-normal-state-map "mf" 'evil-mark-defun) ;mark-defun 相当于C-M-h
(define-key evil-normal-state-map "mh" 'evil-M-h)        ;相当于M-h
(define-key evil-normal-state-map "mxh" 'evil-mark-whole-buffer) ;相当于C-xh
(define-key evil-normal-state-map "mb" 'evil-mark-whole-buffer);相当于C-xh

;; http://vimcdoc.sourceforge.net/doc/motion.html
;; vim 里有
;; |w|向前一个word|
;; |b|向后一个word|
;; |W|向前一个WORD|
;; |B|向后一个WORD|
;;|dw|删除光标后的一个word|
;;|daw|删除光标下的一个word,包括空格|  delete a word
;;|diw|删除光标下的一个word,不包括空格| delete inner word

;; WORD是中间没有空格的一串字符
;; 与emacs中的symbol类似但是不同

;; 下面实现向前向后移动一个symbol,
;; |e|向前移动一个symbol,光标停在下个symbol的开始处|
;; |r|向前移动一个symbol,光标停在下个symbol的结束处|

;; |v|向后移动一个symbol,光标停在下个symbol的开始处|
;; |R|向后移动一个symbol,光标停在下个symbol的结束处|

;; |de|删除一个symbol,不包含空格，==die|
;; |dae|删除一个symbol,含空格|
;; |die|删除一个symbol,不含空格|
;;
;;
;; 这里占用了vim 原有的绑定，包括 e r R v
;; 其中原来的e我觉得用下不大
;; emacs更倾向于在word 或symbol的开头后进行操作，
;; 所以基本上移动到word或symbol的开后进行操作就足够了
;; 而我很少用vim的 r R进行替换操作,所以这两个键被占用了对我没有太大的影响

;; 而影响较大的是v键被占用了，v的功能是开始选中一片区域
;; 之所以占用这个功能是，是我觉得向后移动到symbol的操作是个很常用的操作
;; 我如果持续向后移动，只需要一直按住v就可以了
;; 而所有的选中区域的功能我绑定到了别的键上即sv,
;; 我把s键扩展成了一系列功能键


;; e ,r 移动
(define-key evil-normal-state-map "e" 'evil-forward-symbol-begin)
(define-key evil-normal-state-map "r" 'evil-forward-symbol-end)
;; (define-key evil-normal-state-map "E" 'evil-forward-symbol-end)
(define-key evil-normal-state-map "v" 'evil-backward-symbol-begin)
;; (define-key evil-normal-state-map ";" 'evil-repeat-find-char-or-evil-backward-symbol-begin)
;; (define-key evil-normal-state-map "R" 'evil-backward-symbol-end)

(define-key evil-visual-state-map "e" 'evil-forward-symbol-begin)
(define-key evil-visual-state-map "r" 'evil-forward-symbol-end)
;; (define-key evil-visual-state-map "E" 'evil-forward-symbol-end)
(define-key evil-visual-state-map "v" 'evil-backward-symbol-begin)
;; (define-key evil-visual-state-map "R" 'evil-backward-symbol-end)


;; de dr
(define-key evil-motion-state-map "e" 'evil-forward-symbol-end)
(define-key evil-motion-state-map "r" 'evil-backward-symbol-begin)
;; dae die
(define-key evil-outer-text-objects-map "e" 'evil-a-symbol)
(define-key evil-inner-text-objects-map "e" 'evil-inner-symbol)


;; 多行编辑时 优化性能
(defun vmacs-evil-cleanup-insert-state (orig-fun &rest args)
  (if  (not evil-insert-vcount)
      (apply orig-fun args)
    (let ((vcount (nth 2 evil-insert-vcount))
          (company-mode-p (and (boundp 'company-mode) company-mode))
          (blink-cursor-mode-p (and (boundp 'blink-cursor-mode) blink-cursor-mode))
          (electric-indent-mode-p (and (boundp 'electric-indent-mode) electric-indent-mode))
          (electric-pair-mode-p (and (boundp 'electric-pair-mode) electric-pair-mode))
          (flycheck-mode-p (and (boundp 'flycheck-mode) flycheck-mode))
          (yas-minor-mode-p (and (boundp 'yas-minor-mode) yas-minor-mode))
          (flymake-mode-p (and (boundp 'flymake-mode) flymake-mode))
          (eldoc-mode-p (and (boundp 'eldoc-mode) eldoc-mode))
          (ethan-wspace-mode-p (and (boundp 'ethan-wspace-mode) ethan-wspace-mode)))


      (if (and vcount (> vcount 200))
          (progn
            (jit-lock-mode nil)
            (when electric-indent-mode-p (electric-indent-mode -1))
            (when company-mode-p (company-mode -1) )
            (when blink-cursor-mode-p (blink-cursor-mode -1))
            (when electric-pair-mode-p (electric-pair-mode -1))
            (when flycheck-mode-p (flycheck-mode -1))
            (when flymake-mode-p (flymake-mode -1))
            (when yas-minor-mode-p (yas-minor-mode -1))
            (when eldoc-mode-p (eldoc-mode -1))
            (when ethan-wspace-mode-p (ethan-wspace-mode -1))


            (remove-hook 'pre-command-hook 'evil--jump-hook)


            (apply orig-fun args)

            (jit-lock-mode t)
            (when electric-indent-mode-p (electric-indent-mode t))
            (when company-mode-p (company-mode t))
            (when blink-cursor-mode-p (blink-cursor-mode t))
            (when electric-pair-mode-p (electric-pair-mode t))
            (when flycheck-mode-p (flycheck-mode t))
            (when flymake-mode-p (flymake-mode t))
            (when yas-minor-mode-p (yas-minor-mode t))
            (when eldoc-mode-p (eldoc-mode t))
            (when ethan-wspace-mode-p (ethan-wspace-mode t))
            (add-hook 'pre-command-hook 'evil--jump-hook)
            )


        (apply orig-fun args)
        ))))

(advice-add 'evil-cleanup-insert-state :around #'vmacs-evil-cleanup-insert-state)
;; (advice-remove 'evil-cleanup-insert-state #'vmacs-evil-cleanup-insert-state)

(require 'conf-evil-search)

(provide 'conf-evil)

;; Local Variables:
;; coding: utf-8
;; End:
