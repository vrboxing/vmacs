(deftheme vmacs "Created  2019-06-30.")

(custom-theme-set-faces
 'vmacs
 '(fill-column-indicator ((t (:inherit shadow :stipple nil :foreground "gray35" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal))))
 '(default ((t (:background "#202020" :foreground "#eeeeec" ))))
 '(centaur-tabs-selected-modified ((t (:background "honeydew4" :foreground "white"))))
 '(centaur-tabs-default ((t (:background "#202020" :foreground "#202020" :box nil :overline nil :height 1.1))))
 '(centaur-tabs-selected ((t (:background "gray70" :foreground "black" :box nil :overline nil :height 1.1))))
 '(centaur-tabs-separator ((t (:background "#202020" :foreground "#202020" :height 0.1))))
 '(centaur-tabs-unselected ((t (:background "gray30" :foreground "gray80" :box nil :overline nil :height 1.1))))
 '(bm-face ((t (:background "#272728"))))
 '(buffers-tab ((t (:background "#0C1021" :foreground "#F8F8F8"))))
 '(company-scrollbar-bg ((t (:background "RoyalBlue4"))))
 '(company-scrollbar-fg ((t (:background "green"))))
 '(company-template-field ((t (:background "green" :foreground "black"))))
 '(company-tooltip ((t (:background "gray0" :foreground "green"))))
 '(company-tooltip-annotation ((t (:foreground "#FBDE2D"))))
 '(company-tooltip-common ((t (:foreground "#FBDE2D"))))
 '(company-tooltip-selection ((t (:background "dark slate gray"))))
 '(completions-common-part ((t (:inherit default :foreground "green"))))
 '(completions-first-difference ((t (:inherit default :foreground "yellow" :weight extra-bold ))))
 '(selectrum-primary-highlight ((t (:inherit completions-common-part :weight bold))))
 '(selectrum-secondary-highlight ((t (:inherit selectrum-primary-highlight :foreground "gold1" :underline t))))
 '(selectrum-current-candidate ((t (:inherit highlight :foreground "green"))))
 '(cursor ((t (:background "tomato"))))
 '(custom-comment-tag ((t (:inherit default))))
 '(custom-face-tag ((t (:inherit default))))
 '(custom-group-tag ((t (:inherit variable-pitch :weight bold :height 1.2))))
 '(custom-variable-tag ((t (:inherit default :weight bold))))
 '(diff-added ((t (:foreground "OliveDrab1"))))
 '(diff-changed ((t (:foreground "yellow"))))
 '(diff-context ((t (:inherit default))))
 '(diff-file-header ((t (:foreground "tan1"))))
 '(diff-function ((t (:inherit diff-header :inverse-video t))))
 '(diff-header ((t (:foreground "light steel blue"))))
 '(diff-hunk-header ((t (:inherit diff-header :inverse-video t))))
 '(diff-index ((t (:foreground "Magenta"))))
 '(diff-nonexistent ((t (:foreground "yellow"))))
 '(diff-refine-added ((t (:background "gray26"))))
 '(diff-refine-changed ((t (:background "gray26"))))
 '(diff-refine-removed ((t (:background "gray26"))))
 '(diff-removed ((t (:inherit font-lock-comment-face :slant italic))))
 '(dired-directory ((t (:background "Blue4" :foreground "gray"))))
 '(ediff-current-diff-A ((t (:background "dark cyan"))))
 '(ediff-current-diff-Ancestor ((t (:background "dark red"))))
 '(ediff-current-diff-B ((t (:background "chocolate4"))))
 '(ediff-current-diff-C ((t (:background "sea green"))))
 '(ediff-even-diff-A ((t (:background "gray33"))))
 '(ediff-even-diff-Ancestor ((t (:background "gray40"))))
 '(ediff-even-diff-B ((t (:background "gray35"))))
 '(ediff-even-diff-C ((t (:background "gray49"))))
 '(ediff-fine-diff-A ((t (:background "cadet blue"))))
 '(ediff-fine-diff-Ancestor ((t (:background "sienna1"))))
 '(ediff-fine-diff-B ((t (:background "SlateGray4"))))
 '(ediff-fine-diff-C ((t (:background "saddle brown"))))
 '(ediff-odd-diff-A ((t (:background "gray49"))))
 '(ediff-odd-diff-B ((t (:background "gray50"))))
 '(ediff-odd-diff-C ((t (:background "gray30"))))
 '(erc-command-indicator-face ((t (:background "Purple" :weight bold))))
 '(erc-direct-msg-face ((t (:foreground "Yellow"))))
 '(erc-header-line ((t (:background "GreenYellow" :foreground "Gold"))))
 '(erc-input-face ((t (:foreground "Cyan2"))))
 '(erc-my-nick-face ((t (:foreground "Goldenrod" :weight bold))))
 '(erc-nick-default-face ((t (:foreground "Chartreuse" :weight bold))))
 '(erl-fdoc-name-face ((t (:foreground "green" :weight bold))))
 '(error ((t (:foreground "red" :weight bold))))
 '(flymake-errline ((t (:inherit error :foreground "red"))) t)
 '(flymake-error ((t (:inherit error :foreground "red"))))
 '(font-lock-builtin-face ((t (:foreground "#F8F8F8"))))
 '(font-lock-comment-face ((t (:foreground "#AEAEAE"))))
 '(font-lock-constant-face ((t (:foreground "#D8FA3C"))))
 '(font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
 '(font-lock-done-face ((t (:foreground "Green" :box (:line-width 2 :color "grey75" :style released-button) :height 1.2))) t)
 '(font-lock-function-name-face ((t (:foreground "#FF6400"))))
 '(font-lock-keyword-face ((t (:foreground "#FBDE2D"))))
 '(font-lock-preprocessor-face ((t (:foreground "Aquamarine"))))
 '(font-lock-reference-face ((t (:foreground "SlateBlue"))))
 '(font-lock-regexp-grouping-backslash ((t (:foreground "#E9C062"))))
 '(font-lock-regexp-grouping-construct ((t (:foreground "red"))))
 '(font-lock-string-face ((t (:foreground "light salmon"))))
 '(font-lock-todo-face ((t (:foreground "Red" :box (:line-width 2 :color "grey75" :style released-button) :height 1.2))) t)
 '(font-lock-type-face ((t (:foreground "#8DA6CE"))))
 '(font-lock-variable-name-face ((t (:foreground "#40E0D0"))))
 '(font-lock-warning-face ((t (:foreground "Pink"))))
 '(gui-element ((t (:background "#D4D0C8" :foreground "black"))))
 '(header-line ((t (:background "gray30" :foreground "gray"))))
 '(helm-buffer-directory ((t (:background "Blue4" :foreground "gray"))))
 '(helm-ff-directory ((t (:background "Blue4" :foreground "gray"))))
 '(helm-grep-file ((t (:foreground "cyan1" :underline t))))
 '(helm-match ((t (:foreground "gold1"))))
 '(helm-selection ((t (:background "darkolivegreen" :underline t))))
 '(helm-source-header ((t (:background "gray46" :foreground "yellow" :weight bold :height 1.3 :family "Sans Serif"))))
 '(helm-visible-mark ((t (:background "gray43" :foreground "orange1"))))
 '(highlight ((t (:background "slate gray"))))
 '(highline-face ((t (:background "SeaGreen"))))
 '(hl-paren-face ((t (:overline t :underline t :weight extra-bold))) t)
 '(isearch ((t (:background "seashell4" :foreground "green1"))))
 '(ivy-current-match ((t (:background "RoyalBlue1"))))
 '(ivy-minibuffer-match-face-1 ((t (:inherit comment))))
 '(ivy-minibuffer-match-face-2 ((t (:foreground "green" :weight bold))))
 '(ivy-minibuffer-match-face-3 ((t (:foreground "green" :weight bold))))
 '(ivy-minibuffer-match-face-4 ((t (:foreground "green" :weight bold))))
 '(ivy-posframe ((t (:inherit default :background "gray10"))))
 '(lazy-highlight ((t (:background "ivory4"))))
 '(line-number ((t (:inherit default :foreground "DarkGoldenrod2"))))
 '(line-number-current-line ((t (:inherit line-number :foreground "green"))))
 '(link ((t (:foreground "cyan" :underline t))))
 '(linum ((t (:inherit (shadow default) :foreground "green"))))
 '(linum-relative-current-face ((t (:inherit linum :foreground "#FBDE2D" :weight bold))))
 '(linum-relative-face ((t (:inherit linum :foreground "dark gray"))))
 '(log-view-file ((t (:foreground "DodgerBlue" :weight bold))))
 '(log-view-message ((t (:foreground "Goldenrod" :weight bold))))
 '(magit-branch ((t (:foreground "Green" :weight bold))))
 '(magit-branch-local ((t (:foreground "coral1"))))
 '(magit-branch-remote ((t (:foreground "green1"))))
 '(magit-diff-added ((t (:inherit diff-added))))
 '(magit-diff-added-highlight ((t (:background "gray26" :foreground "green4"))))
 '(magit-diff-context ((t (:inherit diff-context))))
 '(magit-diff-file-heading ((t (:inherit diff-file-header))))
 '(magit-diff-hunk-heading ((t (:inherit diff-hunk-header :inverse-video t))))
 '(magit-diff-removed ((t (:inherit diff-removed))))
 '(magit-header ((t (:foreground "DodgerBlue"))))
 '(magit-log-author ((t (:foreground "Green"))))
 '(magit-log-date ((t (:foreground "cyan"))))
 '(magit-section-heading ((t (:background "gray29" :weight bold))))
 '(minibuffer-prompt ((t (:foreground "salmon1"))))
 '(mode-line ((t (:background "grey75" :foreground "black"))))
 '(mode-line-buffer-id ((t (:background "dark olive green" :foreground "beige"))))
 '(mode-line-highlight ((((class color) (min-colors 88)) nil)))
 '(mode-line-inactive ((t (:background "dark olive green" :foreground "dark khaki" :weight light))))
 '(org-agenda-date ((t (:inherit org-agenda-structure))))
 '(org-agenda-date-today ((t (:inherit org-agenda-date :underline t))))
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date :foreground "green"))))
 '(org-agenda-done ((t (:foreground "#269926"))))
 '(org-agenda-restriction-lock ((t (:background "#FFB273"))))
 '(org-agenda-structure ((t (:foreground "gold1" :weight bold))))
 '(org-date ((t (:foreground "medium sea green" :underline t))))
 '(org-document-info ((t (:foreground "tomato1"))))
 '(org-document-title ((t (:foreground "orchid1" :weight bold))))
 '(org-done ((t (:foreground "green" :weight bold))))
 '(org-drawer ((t (:foreground "purple1"))))
 '(org-ellipsis ((t (:foreground "#FF7400" :underline t))))
 '(org-footnote ((t (:foreground "#1240AB" :underline t))))
 '(org-hide ((t (:foreground "gray20"))))
 '(org-level-1 ((t (:inherit outline-1 :box nil))))
 '(org-level-2 ((t (:inherit outline-2 :box nil))))
 '(org-level-3 ((t (:inherit outline-3 :box nil))))
 '(org-level-4 ((t (:inherit outline-4 :box nil))))
 '(org-level-5 ((t (:inherit outline-5 :box nil))))
 '(org-level-6 ((t (:inherit outline-6 :box nil))))
 '(org-level-7 ((t (:inherit outline-7 :box nil))))
 '(org-level-8 ((t (:inherit outline-8 :box nil))))
 '(org-scheduled-previously ((t (:foreground "#FF7400"))))
 '(org-table ((t (:foreground "cyan"))))
 '(org-tag ((t (:weight bold))))
 '(org-todo ((t (:foreground "#FF6961" :weight bold))))
 '(region ((t (:background "DarkSlateGray"))))
 '(tab-line ((t nil)))
 '(tab-line-highlight ((t (:background "gray100" :foreground "black"))))
 '(tab-line-tab ((t (:background "gray90" :foreground "black" :box (:line-width 1 :style released-button) :height 1.1))))
 '(tab-line-tab-inactive ((t (:inherit tab-line-tab :background "gray30" :foreground "gray90"))))
 '(text-cursor ((t (:background "yellow" :foreground "black"))))
 '(tooltip ((t (:inherit variable-pitch :background "systeminfowindow" :foreground "DarkGreen" :height 2.5))))
 '(transient-argument ((t (:inherit nil :foreground "cyan"))))
 '(transient-value ((t (:foreground "green"))))
 '(underline ((nil (:underline nil))))
 '(vhl/default-face ((t (:background "DarkSlateGray"))))
 '(vmacs-scroll-highlight-line-face ((t (:background "cadetblue4" :foreground "white" :weight bold))))
 '(term-color-black ((t (:background "#8e8e8e" :foreground "#616161"))))
 '(term-color-blue ((t (:background "#c1e3fe" :foreground "#a5d5fe"))))
 '(term-color-cyan ((t (:background "#e5e6fe" :foreground "#d0d1fe"))))
 '(term-color-green ((t (:background "#d6fcb9" :foreground "#b4fa72"))))
 '(term-color-magenta ((t (:background "#ffb1fe" :foreground "#ff8ffd"))))
 '(term-color-red ((t (:background "#ffc4bd" :foreground "#ff8272"))))
 '(term-color-white ((t (:background "#feffff" :foreground "#f1f1f1"))))
 '(term-color-yellow ((t (:background "#fefdd5" :foreground "#fefdc2"))))
 '(warning ((t (:foreground "Salmon" :weight bold))))
 '(web-mode-html-tag-bracket-face ((t (:inherit web-mode-html-tag-face))))
 '(window-divider ((t (:foreground "gray"))))
 '(window-divider-first-pixel ((t (:foreground "yellow"))))
 '(window-divider-last-pixel ((t (:foreground "yellow"))))
 '(woman-addition ((t (:inherit font-lock-builtin-face :foreground "Tan2"))))
 '(woman-bold ((t (:inherit bold :foreground "yellow2"))))
 '(woman-italic ((t (:inherit italic :foreground "green"))))
 '(woman-unknown ((t (:inherit font-lock-warning-face :foreground "Firebrick")))))

(provide-theme 'vmacs)

(when (and (boundp 'custom-theme-load-path)
           load-file-name)
  ;; add theme folder to `custom-theme-load-path' when installing over MELPA
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))




(provide 'vmacs-theme)

;; Local Variables:
;; coding: utf-8
;; End:

;;; vmacs-theme.el ends here.
