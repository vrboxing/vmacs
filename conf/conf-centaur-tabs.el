(require 'centaur-tabs)
(setq-default centaur-tabs-cycle-scope 'tabs)
(setq-default centaur-tabs-display-sticky-function-name nil)
(setq-default centaur-tabs-hide-tabs-hooks   nil)
(setq-default centaur-tabs-style "zigzag")
(global-set-key  (kbd "s-n") 'centaur-tabs-forward)
(global-set-key  (kbd "s-C-M-n") 'centaur-tabs-forward)
(global-set-key  (kbd "s-p") 'centaur-tabs-backward)
(global-set-key  (kbd "s-C-M-p") 'centaur-tabs-backward)
(define-key evil-normal-state-map (kbd "gh") 'centaur-tabs-move-current-tab-to-left)
(define-key evil-normal-state-map (kbd "gl") 'centaur-tabs-move-current-tab-to-right)
;; (vmacs-leader "e" 'centaur-tabs-build-ivy-source)
(vmacs-leader "e" 'centaur-tabs-forward-group)

;; 只为eshell-mode term-mode 启用centaur-tabs

(setq centaur-tabs-buffer-groups-function 'vmacs-centaur-tabs-buffer-groups)

(defun vmacs-centaur-tabs-buffer-groups ()
  "`centaur-tabs-buffer-groups' control buffers' group rules.
    Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
    All buffer name start with * will group to \"Emacs\".
    Other buffer group by `projectile-project-p' with project name."
  (list
   (cond
    ((or (string-match-p "\\*scratch-.*" (buffer-name))
         (derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode))
     "Term")
    ((string-match-p (rx (or
                          "\*Helm"
                          "\*helm"
                          "\*Flymake log\*"
                          "\*Help\*"
                          "\*Ibuffer\*"
                          "\*gopls::stderr\*"
                          "\*gopls\*"
                          "\*sdcv\*"
                          "\*tramp"
                          "\*lsp-log\*"
                          "\*tramp"
                          "\*ccls"
                          "\*vc"
                          "\*xref"
                          "\*Completions\*"
                          "\*Warnings*"
                          "magit-"
                          "\*Async Shell Command\*"
                          "\*Shell Command Output\*"
                          "\*Flycheck error messages\*"
                          "\*Gofmt Errors\*"
                          "\*sdcv\*"
                          "\*Messages\*"
                          "\*Ido Completions\*"
                          ))
                     (buffer-name))
     "Emacs")
    ((not (vmacs-show-tabbar-p)) nil)
    (t "Common"))))

;; (defun vmacs-centaur-tabs-buffer-list ()
;;   "Return the list of buffers to show in tabs.
;; only show eshell-mode term-mode and shell-mode."
;;   (centaur-tabs-filter
;;    #'vmacs-show-tabbar-p
;;    (buffer-list)))
;; (setq centaur-tabs-buffer-list-function 'vmacs-centaur-tabs-buffer-list)

(defun vmacs-show-tabbar-p(&optional buf redisplay)
  (let ((show t))
    (with-current-buffer (or buf (current-buffer))
      (cond
       ((char-equal ?\  (aref (buffer-name) 0))
        (setq show nil))
       ((member (buffer-name) '("*Ediff Control Panel*"
                                "\*Flycheck error messages\*"
                                "\*Gofmt Errors\*"))
        (setq show nil))
       (t t))
      (unless show
        ;; (kill-local-variable 'header-line-format)
        (setq header-line-format nil)
        (when redisplay (redisplay t))
        )
      show)))

(defun vmacs-hide-tab-p(buf)
  (not (vmacs-show-tabbar-p buf t)))

(setq centaur-tabs-hide-tab-function #'vmacs-hide-tab-p)

(defun vmacs-awesome-buffer-order ()
  "Put the two buffers switched to the adjacent position after current buffer changed."
  ;; Don't trigger by centaur-tabs command, it's annoying.
  ;; This feature should trigger by search plugins, such as ibuffer, helm or ivy.
  (when  (and (symbolp this-command)
              (not (string-prefix-p "centaur-tabs" (format "%s" this-command)))
              (not (equal 'mouse-drag-header-line this-command)))
    ;; Just continue when buffer changed.
    (unless (buffer-live-p centaur-tabs-last-focus-buffer)
      (setq centaur-tabs-last-focus-buffer (current-buffer)))
    (when (and (not (eq (current-buffer) centaur-tabs-last-focus-buffer))
               (buffer-live-p centaur-tabs-last-focus-buffer)
               (not (minibufferp)))
      (let* ((current (current-buffer))
             (previous centaur-tabs-last-focus-buffer)
             (current-group (first (funcall centaur-tabs-buffer-groups-function))))
        ;; Record last focus buffer.
        (setq centaur-tabs-last-focus-buffer current)

        ;; Just continue if two buffers are in same group.
        (when (eq current-group centaur-tabs-last-focus-buffer-group)
          (let* ((bufset (centaur-tabs-get-tabset current-group))
                 (current-group-tabs (centaur-tabs-tabs bufset))
                 (current-group-buffers (mapcar 'car current-group-tabs))
                 (current-buffer-index (cl-position current current-group-buffers))
                 (previous-buffer-index (cl-position previous current-group-buffers)))

            ;; If the two tabs are not adjacent, swap the positions of the two tabs.
            (when (and current-buffer-index
                       previous-buffer-index
                       (> (abs (- current-buffer-index previous-buffer-index)) 1))
              (let* ((copy-group-tabs (copy-list current-group-tabs))
                     (previous-tab (nth previous-buffer-index copy-group-tabs))
                     (current-tab (nth current-buffer-index copy-group-tabs))
                     (base-group-tabs (centaur-tabs-remove-nth-element current-buffer-index copy-group-tabs))
                     (new-group-tabs (centaur-tabs-insert-before base-group-tabs previous-tab current-tab)))
                (set bufset new-group-tabs)
                (centaur-tabs-set-template bufset nil)
                (centaur-tabs-display-update)
                ))))

        ;; Update the group name of the last access tab.
        (setq centaur-tabs-last-focus-buffer-group current-group)
        )))
  )

(setq centaur-tabs-adjust-buffer-order-function 'vmacs-awesome-buffer-order)
;; (add-hook 'post-command-hook #'vmacs-awesome-buffer-order)
(centaur-tabs-enable-buffer-reordering)



;; term 分组下 默认选中前一个tab
(defun vmacs-centaur-tabs-buffer-track-killed ()
  "Hook run just before actually killing a buffer.
In Awesome-Tab mode, try to switch to a buffer in the current tab bar,
after the current buffer has been killed.  Try first the buffer in tab
after the current one, then the buffer in tab before.  On success, put
the sibling buffer in front of the buffer list, so it will be selected
first."
  (when (or (string-match-p "\\*scratch-.*" (buffer-name))
            (derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode))
    (and (eq header-line-format centaur-tabs-header-line-format)
         (eq centaur-tabs-current-tabset-function 'centaur-tabs-buffer-tabs)
         (eq (current-buffer) (window-buffer (selected-window)))
         (let ((bl (centaur-tabs-tab-values (centaur-tabs-current-tabset)))
               (b  (current-buffer))
               found sibling)
           (while (and bl (not found))
             (if (eq b (car bl))
                 (setq found t)
               (setq sibling (car bl)))
             (setq bl (cdr bl)))
           (when (and (setq sibling (or sibling (car bl) ))
                      (buffer-live-p sibling))
             ;; Move sibling buffer in front of the buffer list.
             (save-current-buffer
               (switch-to-buffer sibling)))))))


(defun vmacs-awesometab-hook()
  ;; 直接去除自动选下一个tab的hook,让它默认
  (remove-hook 'kill-buffer-hook 'centaur-tabs-buffer-track-killed)
  (add-hook 'kill-buffer-hook 'vmacs-centaur-tabs-buffer-track-killed)
  )

(add-hook 'centaur-tabs-mode-hook #'vmacs-awesometab-hook)


(setq centaur-tabs-label-fixed-length 30)
;; Copied from s.el
(defadvice centaur-tabs-truncate-string (around vmacs-tab activate)
  "If S is longer than LEN, cut it down and add ELLIPSIS to the end.

The resulting string, including ellipsis, will be LEN characters
long.

When not specified, ELLIPSIS defaults to ‘...’."
  (declare (pure t) (side-effect-free t))
  (unless ellipsis (setq ellipsis ""))
  (setq ad-return-value
        (if (> (length s) len)
            (format "%s%s" (substring s 0 (- len (length ellipsis))) ellipsis)
          s)))

(centaur-tabs-mode t)


(provide 'conf-centaur-tabs)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-centaur-tabs.el ends here.
