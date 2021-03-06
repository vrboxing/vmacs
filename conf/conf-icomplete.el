 ;;; Code:
(require 'icomplete)

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
(setq completion-styles '(basic partial-completion substring initials  flex))

(when (require 'orderless nil t)
  (setq completion-styles (cons 'orderless completion-styles)) ;把orderless放到completion-styles 开头
  ;; 默认按空格开隔的每个关键字支持regexp/literal/initialism 3种算法
  (setq orderless-matching-styles '(orderless-regexp orderless-literal orderless-initialism ))
  (defun without-if-$! (pattern _index _total)
    (when (or (string-prefix-p "$" pattern) ;如果以! 或$ 开头，则表示否定，即不包含此关键字
              (string-prefix-p "!" pattern))
      `(orderless-without-literal . ,(substring pattern 1))))
  (defun flex-if-comma (pattern _index _total) ;如果以逗号结尾，则以flex 算法匹配此组件
    (when (string-suffix-p "," pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))
  (defun literal-if-= (pattern _index _total) ;如果以=结尾，则以literal  算法匹配此关键字
    (when (or (string-suffix-p "=" pattern)
              (string-suffix-p "-" pattern)
              (string-suffix-p ";" pattern))
      `(orderless-literal . ,(substring pattern 0 -1))))
  (setq orderless-style-dispatchers '(literal-if-= flex-if-comma without-if-$!)))




(icomplete-mode 1)
(when (require 'icomplete-vertical nil t) (icomplete-vertical-mode))

(define-key icomplete-minibuffer-map (kbd "RET") 'icomplete-fido-ret)
(define-key icomplete-minibuffer-map (kbd "C-m") 'icomplete-fido-ret)
(define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions)
(define-key icomplete-minibuffer-map (kbd "C-s") #'icomplete-forward-completions)
(define-key icomplete-minibuffer-map (kbd "C-r") #'icomplete-backward-completions)
(define-key icomplete-minibuffer-map (kbd "C-.") 'next-history-element)
(define-key icomplete-minibuffer-map (kbd "C-l") #'icomplete-fido-backward-updir)
(define-key icomplete-minibuffer-map (kbd "C-e") #'(lambda(&optional argv)(interactive)(if (eolp) (call-interactively #'icomplete-fido-exit) (end-of-line))) )



(when (require 'embark nil t)
  (when (require 'marginalia nil t) (marginalia-mode 1))
  (setq embark-collect-initial-view-alist '((t . list)))
  (global-set-key (kbd "C-o") 'embark-act)
  (define-key icomplete-minibuffer-map (kbd "C-o") 'embark-act)
  (define-key icomplete-minibuffer-map (kbd "C-o") 'embark-act)
  (define-key icomplete-minibuffer-map (kbd "C-c C-o") 'embar-collect)
  (define-key icomplete-minibuffer-map (kbd "C-c C-c") 'embark-export)
  (define-key icomplete-minibuffer-map (kbd "C-c C-e") 'embark-live-occur)
  (define-key embark-collect-mode-map (kbd "h") nil)
  (define-key embark-collect-mode-map (kbd "v") nil)
  (define-key embark-collect-mode-map (kbd "e") nil)
  (define-key embark-collect-mode-map (kbd "g") nil)
  (defun vmacs-embark-collect-mode-hook ()
    (evil-local-mode)
    (evil-define-key 'normal 'local "/" #'consult-focus-lines)
    (evil-define-key 'normal 'local "z" #'consult-hide-lines)
    (evil-define-key 'normal 'local "r" #'consult-reset-lines))
  (add-hook 'embark-collect-mode-hook 'vmacs-embark-collect-mode-hook)

  )


(defun vmacs-minibuffer-space ()
  (interactive)
  (if (and (string-prefix-p consult-async-default-split (minibuffer-contents))
           (= 2 (length (split-string (minibuffer-contents) consult-async-default-split))))
      (insert consult-async-default-split)
    (insert " ")))

(define-key icomplete-minibuffer-map (kbd "SPC") 'vmacs-minibuffer-space)

(fset 'imenu 'consult-imenu)
(setq consult-project-root-function #'vc-root-dir)
(setq consult-async-default-split "#")
(with-eval-after-load 'consult
  (add-to-list 'consult-buffer-sources 'vmacs-consult--source-dired t)
  (add-to-list 'consult-buffer-sources 'vmacs-consult--source-git t))

(vmacs-leader " " 'consult-buffer)
(vmacs-leader "fo" 'consult-buffer-other-window)
(vmacs-leader "gG" #'consult-grep)
(vmacs-leader "gg" #'(lambda()(interactive) (consult-ripgrep default-directory)))
(vmacs-leader "gt" #'consult-ripgrep)
(vmacs-leader "g." #'(lambda()(interactive) (consult-ripgrep default-directory (thing-at-point 'symbol))))
(vmacs-leader "g," #'(lambda()(interactive) (consult-ripgrep nil (thing-at-point 'symbol)) ))
(vmacs-define-key  'global "g/" 'consult-focus-lines nil 'normal)
(global-set-key [remap goto-line] 'consult-goto-line)
(global-set-key (kbd "C-c C-s") 'consult-line)

(defadvice yank-pop (around icomplete-mode (arg) activate)
  (interactive "p")
  (let ((icomplete-separator (concat "\n" (propertize (make-string 60 ?— ) 'face 'vertical-border) "\n ")))
    ad-do-it))



(provide 'conf-icomplete)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-icomplete.el ends here.
