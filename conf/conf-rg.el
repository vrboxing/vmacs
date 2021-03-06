;; https://github.com/dajva/rg.el
;; doc https://rgel.readthedocs.io
;; -g '!elpa' 不包含elpa
;; -g '*.el' 包含 el文件
;;; Code:
(require 'rg)
(setq rg-show-header t)
(setq rg-command-line-flags '("-z" "--pcre2"))
(setq rg-group-result nil);bug enable-wgrep-when-entry-insert
(vmacs-leader (kbd "g") rg-global-map)

(define-key rg-global-map (kbd ".") #'vmacs-rg-dwim-current-dir)
(define-key rg-global-map (kbd ",") #'vmacs-rg-dwim-project-dir)
(define-key rg-global-map "g" #'vmacs-rg-word-current-dir)
(define-key rg-global-map "t" #'vmacs-rg-word-root-dir)
(define-key rg-global-map "m" #'rg-menu)


;; 默认非正则 C-u 使用有单词边界的正则，C-uC-u 使用用户输入的正则（不含边界）
(rg-define-search  vmacs-rg-word-current-dir
  :query (vmacs-rg-query (vmacs-rg-read-regex "Regexp at ." (thing-at-point 'symbol) "")
                         (= 4 (prefix-numeric-value current-prefix-arg)))
  :format regexp
  :flags ("--type=all")
  :files current :dir current)

(rg-define-search vmacs-rg-word-root-dir
  :query (vmacs-rg-query (vmacs-rg-read-regex "Regexp at project root " (thing-at-point 'symbol) "" )
                         (= 4 (prefix-numeric-value current-prefix-arg)))
  :format regexp
  :flags ("--type=all")
  :files current :dir project)

;; 默认 使用有单词边界的正则，C-u 使用非正则，C-uC-u 使用用户输入的正则（不含边界）
(rg-define-search vmacs-rg-dwim-current-dir
  "Search for thing at point in files matching the current file
under the current directory."
  :query (vmacs-rg-query nil (= 1 (prefix-numeric-value current-prefix-arg)))
  :format (= 4 (prefix-numeric-value current-prefix-arg))      ;无prefix arg 或prefix>4 使用regex，否是非正则
  :flags ("--type=all")
  :files current
  :dir current)

(rg-define-search vmacs-rg-dwim-project-dir
  "Search for thing at point in files matching the current file
under the project root directory."
  :query (vmacs-rg-query nil (= 1 (prefix-numeric-value current-prefix-arg)))
  :format (= 4 (prefix-numeric-value current-prefix-arg))      ;无prefix arg 或prefix>4 使用regex，否是非正则
  :flags ("--type=all")
  :files current
  :dir project)

;; c toggle case
(defun vmacs-rg-hook()
  (setq-local scroll-conservatively 101)
  (setq-local scroll-margin 0)
  (setq-local compilation-scroll-output 'first-error)
  (setq-local compilation-always-kill t)
  (define-key rg-mode-map "g" nil)
  (define-key rg-mode-map "e" nil)
  (define-key rg-mode-map "i" nil)
  (define-key rg-mode-map "s" nil)
  (define-key rg-mode-map "l" nil)
  (define-key rg-mode-map "h" nil)
  (define-key rg-mode-map " " nil)
  (define-key rg-mode-map "\M-n" 'rg-next-file)
  (define-key rg-mode-map "\M-p" 'rg-prev-file)
  (define-key rg-mode-map (kbd "L") 'rg-forward-history)
  (define-key rg-mode-map (kbd "H") 'rg-back-history)
  (define-key rg-mode-map "I" #'rg-rerun-toggle-ignore)
  (define-key rg-mode-map (kbd "z") #'vmacs-rg-rerun-hide-matched)
  (define-key rg-mode-map (kbd "r") #'vmacs-rg-rerun-change-regex)
  (define-key rg-mode-map (kbd "/") #'vmacs-rg-rerun-change-regex)
  (evil-define-key 'normal 'local "x" 'vmacs-rg-rerun-filter-by-file) ;C-ux 则
  (evil-define-key 'normal 'local "c" 'vmacs-rg-rerun-toggle-surround)
  (evil-define-key 'normal 'local "gr" 'rg-recompile))

(add-hook 'rg-mode-hook #'vmacs-rg-hook)
(defconst rg-symbol-prefix "(?<![a-zA-Z0-9_-])" )
(defconst rg-symbol-suffix  "(?![a-zA-Z0-9-_])" )
;; 0宽断言
;; https://leongfeng.github.io/2017/03/10/regex-java-assertions/
;;  '(?<![a-zA-Z0-9_-])(world)(?![a-zA-Z0-9-_])' ;
;; 搜索world ，只是它前后不能包含a-z等字符， 基本等价于\bworld\b
;; 但是\b 对于_- 也当作单词边界,并不符合我的预期
;;
;; 利用0宽断言作多关键字匹配，
;; rg --pcre2    '^(?=.*hello)^(?=.*world)' #include hello and world
;; rg --pcre2    '^(?!.*hello)^(?=.*world)' # include world ,exclude hello
;; hello  world
;; world  hello
;; world  foo
;; hello !world 包含hello 不包含world
(defun vmacs-rg-query(&optional val surround-as-symbol)
  (unless val (setq val (thing-at-point 'symbol)))
  (let ((tokens (split-string val " " t))
        (regex ""))
    (dolist (token tokens)
      (if (char-equal ?! (car (string-to-list token)))
          (setq regex (format "%s^(?!.*%s)" regex (substring token 1 (length token))))
        (setq regex (format "%s^(?=.*%s)" regex token ))))
    (when (= 1 (length tokens)) (setq regex val))
    (if surround-as-symbol
        (format "%s%s%s" rg-symbol-prefix regex rg-symbol-suffix)
      regex)))

(defun vmacs-rg-unquote (val )
  (when  (string-prefix-p rg-symbol-prefix val)
    (setq val (substring  val (length rg-symbol-prefix))))
  (when (string-suffix-p rg-symbol-suffix val)
    (setq val (substring  val 0 (- (length val) (length rg-symbol-suffix)))))
  (while (string-match "\\(\\^(\\?!\\.\\*\\(.+?\\))\\)" val)
    (setq val (replace-match (format "!%s " (match-string 2 val)) t t val 1)))
  (while (string-match "\\(\\^(\\?=\\.\\*\\(.+?\\))\\)" val)
    (setq val (replace-match (format "%s " (match-string 2 val)) t t val 1)))
  (string-trim val))


(defun vmacs-rg-read-regex (&optional prompt def pattern suffix)
  (let ((pattern (or pattern (rg-search-pattern rg-cur-search)))
        (read-from-minibuffer-orig (symbol-function 'read-from-minibuffer)))
    (setq pattern (vmacs-rg-unquote pattern))
    (setq pattern (concat pattern  (or suffix "")))
    (cl-letf (((symbol-function #'read-from-minibuffer)
               (lambda (prompt &optional _  &rest args)
                 (print def)
                 (apply read-from-minibuffer-orig prompt pattern  args))))
      (read-regexp (or prompt "regexp: " ) def 'rg-pattern-history))))

(defun vmacs-rg-rerun-change-regex (&optional suffix)
  "Rerun last search but prompt for new regexp."
  (interactive)
  (let ((pattern (vmacs-rg-read-regex nil nil nil (or suffix " "))))
      (setf (rg-search-pattern rg-cur-search)
            (vmacs-rg-query pattern nil))
      (rg-rerun)))

(defun vmacs-rg-rerun-hide-matched (&optional suffix)
  "Rerun last search but prompt for new regexp."
  (interactive)
  (vmacs-rg-rerun-change-regex " !"))

(defun vmacs-rg-rerun-toggle-surround ()
  "Rerun last search but prompt for new search pattern.
IF LITERAL is non nil this will trigger a literal search, otherwise a regexp search."
  (interactive)
  (let ((pattern (rg-search-pattern rg-cur-search)))
    ;; Override read-from-minibuffer in order to insert the original
    ;; pattern in the input area.
    (if (not (string-prefix-p rg-symbol-prefix pattern))
        (setq pattern (format "%s%s%s" rg-symbol-prefix pattern rg-symbol-suffix))
      (setq pattern (substring  pattern (length rg-symbol-prefix)))
      (when (string-suffix-p rg-symbol-suffix pattern)
        (setq pattern (substring  pattern 0 (- (length pattern) (length rg-symbol-suffix))))))
    (setf (rg-search-pattern rg-cur-search) pattern)
    (setf (rg-search-literal rg-cur-search) nil)
    (rg-rerun)))


(defun vmacs-rg-rerun-filter-by-file ()
  "Rerun last search but exclude selected filename or diredctory with flag: --glob='!*name*'"
  (interactive)
  (let ((flags (rg-search-flags rg-cur-search))
        (dir (read-string (format "%s(file or dir): " (if current-prefix-arg "include" "exclude")))))
    (setq flags (append flags (list (format "--glob='%s*%s*'" (if current-prefix-arg "" "!") dir))))
    (setf (rg-search-flags rg-cur-search) flags)
    (rg-rerun)))

;; ;;;###autoload
;; (defun rg-occur-hide-lines-not-matching (search-text)
;;   "Hide lines that don't match the specified regexp."
;;   (interactive "MHide lines not matched by regexp: ")
;;   (set (make-local-variable 'line-move-ignore-invisible) t)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (forward-line 5)
;;     (let ((inhibit-read-only t)
;;           line)
;;       (while (not (looking-at-p "^\nrg finished "))
;;         (setq line (buffer-substring-no-properties (point) (point-at-eol)))
;;         (if (string-match-p search-text line)
;;             (forward-line)
;;           (when (not (looking-at-p "^\nrg finished "))
;;             (delete-region (point) (1+ (point-at-eol)))))))))

;; ;;;###autoload
;; (defun rg-occur-hide-lines-matching  (search-text)
;;   "Hide lines matching the specified regexp."
;;   (interactive "MHide lines matching regexp: ")
;;   (set (make-local-variable 'line-move-ignore-invisible) t)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (forward-line 5)
;;     (let ((inhibit-read-only t)
;;           line)
;;       (while (not (looking-at-p "^\nrg finished "))
;;         (setq line (buffer-substring-no-properties (point) (point-at-eol)))
;;         (if (not (string-match-p search-text line))
;;             (forward-line)
;;           (when (not (looking-at-p "^\nrg finished "))
;;             (delete-region (point) (1+ (point-at-eol)))))))))


(provide 'conf-rg)

;; Local Variables:
;; coding: utf-8
;; End:

;;; conf-rg.el ends here.
