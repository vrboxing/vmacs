;;; ivy-dired-history.el --- use ivy to open recent directories

;; Author: 纪秀峰 <jixiuf@gmail.com>
;; Copyright (C) 2017 纪秀峰, all rights reserved.
;; Created:  2017-06-14
;; Version: 1.0
;; X-URL:https://github.com/jixiuf/ivy-dired-history
;; Package-Requires: ((ivy "0.9.0")(counsel "0.9.0")(cl-lib "0.5"))
;;
;; Features that might be required by this library:
;;
;; `ivy' `counsel'
;;
;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; use `ivy' to open recent directories.

;; it is integrated with `dired-do-copy' and `dired-do-rename'.
;; when you press C (copy) or R (rename) , it is excellent to
;; allow users to select a directory from the recent dired history .



;;; Installation:

;; (require 'savehist)
;; (add-to-list 'savehist-additional-variables 'vmacs-dired-history)
;; (savehist-mode 1)

;; or if you use desktop-save-mode
;; (add-to-list 'desktop-globals-to-save 'vmacs-dired-history)


;; (with-eval-after-load 'dired
;;   (require 'vmacs-dired-history)
;; ;; if you are using ido,you'd better disable ido for dired
;; ;; (define-key (cdr ido-minor-mode-map-entry) [remap dired] nil) ;in ido-setup-hook
;;   (define-key dired-mode-map "," 'dired))


;;; Code:

(require 'dired)
(require 'dired-aux)
(require 'cl-lib)

(defgroup vmacs-dired-history nil
  "dired history using Ivy"
  :group 'ivy)


(defcustom vmacs-dired-history-max 200
  "Length of history for ivy-dired-history."
  :type 'number
  :group 'vmacs-dired-history)

(defcustom vmacs-dired-history-ignore-directory '("/")
  "Length of history for ivy-dired-history."
  :type '(repeat string)
  :group 'vmacs-dired-history)

(defvar vmacs-dired-history nil)

(defvar vmacs-dired-history--cleanup-p nil)
(defvar vmacs-dired-history--default-directory nil)

(defun vmacs-dired-history--update(dir)
  "Update variable `vmacs-dired-history'.
Argument DIR directory."
       (setq dir (abbreviate-file-name (expand-file-name dir)))
       (unless (member dir vmacs-dired-history-ignore-directory)
         (unless vmacs-dired-history--cleanup-p
           (setq vmacs-dired-history--cleanup-p t)
           (let ((tmp-history ))
             (dolist (d vmacs-dired-history)
               (when (or (file-remote-p d) (file-directory-p d))
                 (add-to-list 'tmp-history d t)))
             (setq vmacs-dired-history tmp-history)))
         (setq vmacs-dired-history
               (delete-dups (delete dir vmacs-dired-history)))
         (setq vmacs-dired-history
               (append (list dir) vmacs-dired-history))
         (vmacs-dired-history--trim)))

(defun vmacs-dired-history-update()
  "Update variable `vmacs-dired-history'."
  (vmacs-dired-history--update (dired-current-directory)))

;;when you open dired buffer ,update `vmacs-dired-history'.
(add-hook 'dired-after-readin-hook 'vmacs-dired-history-update)

(defun vmacs-dired-history--trim()
  "Retain only the first `vmacs-dired-history-max' items in VALUE."
  (if (> (length vmacs-dired-history) vmacs-dired-history-max)
      (setcdr (nthcdr (1- vmacs-dired-history-max) vmacs-dired-history) nil)))


;; integrating dired history feature into commands like
;; dired-do-copy and dired-do-rename.
;;see https://github.com/jixiuf/ivy-dired-history/issues/6
(defadvice dired-mark-read-file-name(around vmacs-dired-history activate)
  "Wrapper ‘read-file-name’ with idv-dired-history-read-file-name."
  (cl-letf (((symbol-function 'read-file-name)
             #'vmacs-dired-history--read-file-name))
    ad-do-it))

(defadvice dired-read-dir-and-switches(around vmacs-dired-history activate)
  "Wrapper ‘read-file-name’ with idv-dired-history-read-file-name."
  (vmacs-dired-history--update (expand-file-name default-directory))
  (let ((default-directory default-directory))
    ;; (unless (next-read-file-uses-dialog-p) (setq default-directory "/"))
    (cl-letf (((symbol-function 'read-file-name)
               #'vmacs-dired-history--read-file-name))
      ad-do-it)))

(defadvice dired-do-compress-to(around vmacs-dired-history activate)
  "Wrapper ‘read-file-name’ with idv-dired-history-read-file-name."
  (cl-letf (((symbol-function 'read-file-name)
             #'vmacs-dired-history--read-file-name))
    ad-do-it))

(defun vmacs-dired-history--read-file-name
    (prompt &optional dir default-filename mustmatch initial predicate)
  ""
  (let ((default-directory default-directory))
    (when dir (setq default-directory dir))
    (setq vmacs-dired-history--default-directory default-directory)
    (completing-read prompt 'vmacs-dired-history---read-file-name
                     predicate mustmatch initial)))


(defalias 'vmacs-dired-history--old-read-file-name-internal
  (completion-table-in-turn #'completion--embedded-envvar-table
                            #'completion--file-name-table)
  "same as read-file-name-internal")

(defun vmacs-dired-history---read-file-name (string pred action)
  "Merge ivy-directory-history-variables with files in current directory.
Argument STRING string.
Argument PRED pred.
Argument ACTION action."
  (let ((cands vmacs-dired-history))
    (append cands
            (vmacs-dired-history--old-read-file-name-internal string pred action))))


(provide 'vmacs-dired-history)

;; Local Variables:
;; coding: utf-8
;; End:

;;; vmacs-dired-history.el ends here.
