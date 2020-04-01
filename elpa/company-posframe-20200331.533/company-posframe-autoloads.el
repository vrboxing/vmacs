;;; company-posframe-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "company-posframe" "company-posframe.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from company-posframe.el

(defvar company-posframe-mode nil "\
Non-nil if Company-Posframe mode is enabled.
See the `company-posframe-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `company-posframe-mode'.")

(custom-autoload 'company-posframe-mode "company-posframe" nil)

(autoload 'company-posframe-mode "company-posframe" "\
company-posframe minor mode.

If called interactively, enable Company-Posframe mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "company-posframe" '("company-posframe-")))

;;;***

;;;### (autoloads nil nil ("company-posframe-pkg.el" "company-posframe-quickhelp.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; company-posframe-autoloads.el ends here
