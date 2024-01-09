;;; dosbox-black-theme.el --- The dosbox-black color theme

(unless (>= emacs-major-version 24)
  (error "The dosbox-black theme requires Emacs 24 or later!"))

(deftheme dosbox-black "The dosbox-black color theme")

;; Monokai colors
(defcustom dosbox-black-theme-yellow "#E6DB74" "Primary colors - yellow" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-orange "#FD971F" "Primary colors - orange" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-red "#F92672" "Primary colors - red" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-magenta "#FD5FF0" "Primary colors - magenta" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-blue "#66D9EF" "Primary colors - blue" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-green "#A6E22E" "Primary colors - green" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-cyan "#A1EFE4" "Primary colors - cyan" :type 'string :group 'monokai)
(defcustom dosbox-black-theme-violet "#AE81FF" "Primary colors - violet" :type 'string :group 'monokai)

(let ((background "#000000")
      (gutters    "#062329")
      (gutter-fg  "#062329")
      (gutters-active "#062329")
      (builtin      "#DAB98F")
      (selection  "#000000")
      (text       "#b1b1b1")
      (comments   "#d04863")
      (punctuation "#00AA00")
      (keywords "#eaf0e5")
      (variables "#eaf0e5")
      (functions "#FFFFFF")
      (methods    "#FFFFFF")
      (strings    "#efb6a6")
      (constants "#7c80f8")
      (macros "#B0B0B0")
      (numbers "#7c80f8")
      (white     "#ffffff")
      (error "#250909")
      (warning "#250909")
      (highlight-line "midnight blue")
      (line-fg "#F0F0F0"))

  (custom-theme-set-faces
   'dosbox-black

   ;; Default colors
   ;; *****************************************************************************

   `(default                          ((t (:foreground ,text :background ,background, :weight normal))))
   `(region                           ((t (:foreground nil :background ,selection))))
   `(cursor                           ((t (:background ,"#FFFF00"                        ))))
   `(fringe                           ((t (:background ,background   :foreground ,white))))
   `(linum                            ((t (:background ,background :foreground ,gutter-fg))))
   `(highlight ((t (:foreground nil :background,selection))))

   ;; Font lock faces
   ;; *****************************************************************************

   `(font-lock-keyword-face           ((t (:foreground ,keywords))))
   `(font-lock-type-face              ((t (:foreground ,keywords))))
   `(font-lock-constant-face          ((t (:foreground ,constants))))
   `(font-lock-variable-name-face     ((t (:foreground ,text))))
   `(font-lock-builtin-face           ((t (:foreground ,builtin))))
   `(font-lock-string-face            ((t (:foreground ,strings))))
   `(font-lock-comment-face           ((t (:foreground ,comments))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comments))))
   `(font-lock-doc-face               ((t (:foreground ,comments))))
   `(font-lock-function-name-face     ((t (:foreground ,functions))))
   `(font-lock-doc-string-face        ((t (:foreground ,strings))))
   `(font-lock-preprocessor-face      ((t (:foreground ,macros))))
   `(font-lock-warning-face           ((t (:foreground ,warning))))
   `(font-lock-punctuation-face       ((t (:foreground ,punctuation))))
   
   ;; Plugins
   ;; *****************************************************************************
   `(trailing-whitespace ((t (:foreground nil :background ,warning))))
   `(whitespace-trailing ((t (:background nil :foreground ,warning :inverse-video t))))

   `(linum ((t (:foreground ,line-fg :background ,background))))
   `(linum-relative-current-face ((t (:foreground ,white :background ,background))))
   `(line-number ((t (:foreground ,line-fg :background ,background))))
   `(line-number-current-line ((t (:foreground ,white :background ,background))))

   ;; hl-line-mode
   `(hl-line ((t (:background ,highlight-line))))
   `(hl-line-face ((t (:background ,highlight-line))))

   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,punctuation))));dosbox-black-theme-violet))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-10-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-11-face ((t (:foreground ,punctuation))))
   `(rainbow-delimiters-depth-12-face ((t (:foreground ,punctuation))))

   ;; mode-line and powerline
   `(mode-line-buffer-id ((t (:foreground ,background :distant-foreground ,text :text ,text :weight bold))))
   `(mode-line ((t (:inverse-video unspecified
                                   :underline unspecified
                                   :foreground ,background
                                   :background ,text
                                   :box nil))))
   `(powerline-active1 ((t (:background ,text :foreground ,background))))
   `(powerline-active2 ((t (:background ,text :foreground ,background))))

   `(mode-line-inactive ((t (:inverse-video unspecified
                                            :underline unspecified
                                            :foreground ,text
                                            :background ,background
                                            :box nil))))
   `(powerline-inactive1 ((t (:background ,background :foreground ,text))))
   `(powerline-inactive2 ((t (:background ,background :foreground ,text))))

    ;; better compatibility with default DOOM mode-line
   `(error ((t (:foreground nil :weight normal))))
   `(doom-modeline-project-dir ((t (:foreground nil :weight bold))))
   
   ;; js2-mode
   `(js2-function-call ((t (:inherit (font-lock-function-name-face)))))
   `(js2-function-param ((t (:foreground ,text))))
   `(js2-jsdoc-tag ((t (:foreground ,keywords))))
   `(js2-jsdoc-type ((t (:foreground ,constants))))
   `(js2-jsdoc-value((t (:foreground ,text))))
   `(js2-object-property ((t (:foreground ,text))))
   `(js2-external-variable ((t (:foreground ,constants))))
   `(js2-error ((t (:foreground ,error))))
   `(js2-warning ((t (:foreground ,warning))))

   ;; highlight numbers
   `(highlight-numbers-number ((t (:foreground ,numbers))))
  )

  (custom-theme-set-variables
    'dosbox-black
    '(linum-format " %5i ")
  )
)

(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(font-lock-add-keywords
 'c++-mode
 '(("\\(*\\|->\\|&\\|=\\|-\\|+\\|/\\||\\|!\\)" 1 'font-lock-punctuation-face append))
 )

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

;; *****************************************************************************

(provide-theme 'dosbox-black)

;; Local Variables:
;; no-byte-compile: t
;; End:

(provide 'dosbox-black-theme)

;;; dosbox-black-theme.el ends here
