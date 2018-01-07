;;; conf-term.el --- Description

;; Author: 纪秀峰  jixiuf@gmail.com
;; Keywords:
;; URL:

;; Copyright (C) 2017, 纪秀峰, all rights reserved.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

;; . 如果你使用的是mac系统，发现multi-term每行出出了4m，在shell里运
;;  行下：tic -o ~/.terminfo  /Applications/Emacs.app/Contents/Resources/etc/e/eterm-color.ti
;;  Use Emacs terminfo, not system terminfo, mac系统出现了4m
;; (setq system-uses-terminfo nil)

(setq-default shell-toggle-full-screen-window-only t) ;toggle term buffer fullscreen
(setq-default shell-toggle-goto-eob nil)
(setq-default term-prompt-regexp "^[^#$%>\n]*[#$%>] *") ;默认regex 相当于没定义，term-bol无法正常中转到开头处

(require 'sane-term)

(define-key term-mode-map (kbd "C-M-S-s-p") 'sane-term-prev)
(define-key term-mode-map (kbd "C-M-S-s-n") 'sane-term-next)
;; (define-key term-mode-map (kbd "C-a") 'vmacs-term-bol)
(define-key term-raw-map (kbd "C-M-S-s-n") 'sane-term-next)
(define-key term-raw-map (kbd "C-M-S-s-p") 'sane-term-prev)
(define-key term-raw-map (kbd "C-g") 'term-ctrl-g)
(define-key term-raw-map (kbd "C-k") 'term-ctrl-k)

(define-key term-raw-map (kbd "C-t") 'vmacs-shell-toggle-new)
(define-key term-mode-map (kbd "C-t") 'vmacs-shell-toggle-new)


(setq term-buffer-maximum-size 10000)

(defun term-kill-auto-exit()
  (let ((p(get-buffer-process (current-buffer))))
    (when p
      (set-process-query-on-exit-flag p nil))))

(add-hook 'term-exec-hook 'term-kill-auto-exit)

;; (defadvice evil-normal-state (after term-send-raw first activate)
;;   "send C-g "
;;   (when  (derived-mode-p 'term-mode)
;;       (call-interactively 'term-send-raw)
;;       ))

;; "进入term 输入命令模式"
(defun evil-insert-state-term-char-mode ()
  (when (and  (derived-mode-p 'term-mode)
              (get-buffer-process (current-buffer)))
    (when (term-in-line-mode) (term-char-mode))))
(add-hook 'evil-insert-state-entry-hook 'evil-insert-state-term-char-mode)

(defadvice evil-paste-after (around paste-to-term activate)
  (if (derived-mode-p 'term-mode)
      (term-send-raw-string (evil-get-register ?\" t))
      ad-do-it
    )) ; evil 所有的操作yank/delete/等都会把内容放到 "寄存器中

(defadvice evil-paste-before (around paste-to-term activate)
  (if (derived-mode-p 'term-mode)
      (term-send-raw-string (evil-get-register ?\" t))
    ad-do-it
    )) ;evil 所有的操作yank/delete/等都会把内容放到 "寄存器中


(defadvice yank (around paste-to-term activate)
  (if (derived-mode-p 'term-mode)
      (term-send-raw-string (evil-get-register ?\" t))
    ad-do-it
    )) ;evil 所有的操作yank/delete/等都会把内容放到 "寄存器中

(defun term-ctrl-g ()
  "term ctrl-g"
  (interactive)
  (if (equal last-command 'term-ctrl-g)
      (progn (evil-normal-state)
             (when (term-in-char-mode) (term-line-mode)))
    (term-send-raw)))


;; (term-send-raw-string "\^g") ;; send ctrl-g
;; (term-send-raw-string (string ?\e)) ; send esc


;; (define-key term-raw-map (kbd "C-y") nil)

(defun term-ctrl-k(&optional arg)
  "this function is a wrapper of (kill-line).
   When called interactively with no active region, this function
  will call (kill-line) ,else kill the region."
  (interactive "P")
  (vmacs-kill-region-or-line arg)
  (term-send-raw-string "\^K"))

(provide 'conf-term)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-term.el ends here.
