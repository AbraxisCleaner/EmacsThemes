(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

(setq visible-bell 1)
(setq scroll-step 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(setq casey-win32 1)

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq enable-local-variables nil)
(when casey-win32 
  (setq casey-makescript "build.bat")
  (setq casey-font "outline-Liberation Mono")
  )
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

; Turn off the toolbar
(tool-bar-mode 0)
(global-hl-line-mode 1)

(load-library "view")
(require 'cc-mode)
(require 'ido)
(require 'compile)
(ido-mode t)

; Setup my compilation mode
(defun casey-big-fun-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
  )

; Bright-red TODOs
 (setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
 (make-face 'font-lock-fixme-face)
 (make-face 'font-lock-note-face)
 (mapc (lambda (mode)
	 (font-lock-add-keywords
	  mode
	  '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
            ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
	fixme-modes)
 (modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
 (modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)

; Accepted file extensions and their appropriate modes
(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ) auto-mode-alist))

; C++ indentation style
(defconst casey-big-fun-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  c-lineup-for)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
    "Casey's Big Fun C++ Style")


; CC++ mode handling
(defun casey-big-fun-c-hook ()
  ; Set my style for the current buffer
  (c-add-style "BigFun" casey-big-fun-c-style t)
  
  ; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)

  ; No hungry backspace
  (c-toggle-auto-hungry-state -1)
  
  ; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ; Newline indents, semi-colon doesn't
  (define-key c++-mode-map "\C-m" 'newline-and-indent)
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

  ; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)

  ; Abbrevation expansion
  (abbrev-mode 1) 

  (defun casey-find-corresponding-file ()
    "Find the file that corresponds to this one."
    (interactive)
    (setq CorrespondingFileName nil)
    (setq BaseFileName (file-name-sans-extension buffer-file-name))
    (if (string-match "\\.c" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".h")))
    (if (string-match "\\.h" buffer-file-name)
       (if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
	   (setq CorrespondingFileName (concat BaseFileName ".cpp"))))
    (if (string-match "\\.hin" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".cin")))
    (if (string-match "\\.cin" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".hin")))
    (if (string-match "\\.cpp" buffer-file-name)
       (setq CorrespondingFileName (concat BaseFileName ".h")))
    (if CorrespondingFileName (find-file CorrespondingFileName)
       (error "Unable to find a corresponding file")))
  (defun casey-find-corresponding-file-other-window ()
    "Find the file that corresponds to this one."
    (interactive)
    (find-file-other-window buffer-file-name)
    (casey-find-corresponding-file)
    (other-window -1))
  (define-key c++-mode-map [f12] 'casey-find-corresponding-file)
  (define-key c++-mode-map [M-f12] 'casey-find-corresponding-file-other-window)

  ; devenv.com error parsing
  (add-to-list 'compilation-error-regexp-alist 'casey-devenv)
  (add-to-list 'compilation-error-regexp-alist-alist '(casey-devenv
   "*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
    2 3 nil (4)))
)

(defun casey-replace-string (FromString ToString)
  "Replace a string without moving point."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion
    (replace-string FromString ToString)
  ))
(define-key global-map [f8] 'casey-replace-string)

(add-hook 'c-mode-common-hook 'casey-big-fun-c-hook
	  
(define-key global-map "\e " 'set-mark-command))

(defun maximize-frame ()
    "Maximize the current frame"
     (interactive)
     (w32-send-sys-command 61488))

; Compilation
(setq compilation-context-lines 0)
(setq compilation-error-regexp-alist
    (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
     compilation-error-regexp-alist))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p casey-makescript) t
      (cd "../")
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile casey-makescript))
  (other-window 1))
(define-key global-map "\em" 'make-without-asking)

; Clock
(display-time)

; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
(split-window-horizontally)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(auto-save-interval 0)
 '(auto-save-list-file-prefix nil)
 '(auto-save-timeout 0)
 '(auto-show-mode t t)
 '(custom-enabled-themes '(dosbox-black))
 '(custom-safe-themes
   '("fb7ca6d7f7d9c7f1d7f8670c221f08e4030966cc6dae2f26100f5e7285289c8c" "46644c7b740e8f00586e7078e9d1cd4fed3d4df904680692743be3fc1e057785" "2ccd5b78ee89e3a80e359b23b4169198b4d35f75545ae6e6aa51aeed9f3f73d0" "f110f17d95510af8501cd3ff9db013ada433b5c8dfc9a7dcfd1346187be055d7" "48d68c5336d31be959fa46ec611fb7669587ea358e269ff3023dd8b10e93fb6a" "f7b2c785c6f7c1d568d7f7e9acd137559ea885675600f1b0a025338f2a807a3a" "75397ddfaa4ef9fa6bc3e9c90c380b0c25fb620511d3dfc731e493a374656184" "422a414698748d41952a1602365361255bd6ac9f143abe868cecdc6954d9145a" "ff87fcb548018eba80f65aab2378eb2294be2eb73edd1bc21dbff4e13c92a0ea" "0d701d2ae223e4f445b92dd5dbe7acdc62de3ee6ead022bea1afd33fb85a6d2c" "ed80bed0661b42b076a3971657d2496f51b43e930669308280ba06e10ec5dfe3" "779a6f4e9157a536c39d64e9e05d84a47ef2b0c0f76c6697a61ec3aecfb3f567" "a7d6978ca86743827cb86397867eb0d7e1f3c2f0bffe27972894371fddd35648" "774cf631c190da702947b8213432699a3b916fa7454519abca541eff869883d7" "f5461ba41e4f28ee25b7809ecb513190027973c7e29b404cde829964ccaa855b" "60c99a50eded3b717bd3edf3c5856da09b19668c860048773f4e372881f978b0" "b464010ebdb686aa7eecb509863afe26f90bb5da5319fa7350c58c5f21c48aee" "67704b20bccaa24353fca9c186cb34632514cd7a11ee431bbe1b002f568ef7dc" "5a70053ee38a216b07429c28c7bd6740423b24b6367c906f68f3d6b03c7fd113" "e0bc2ca0a934e755c61838c48db7f0e4c78b6a73470abab5cb4c7973cced4a2a" "c484142a3b9a1b46a6e5a52d3eaec0e8bc8f41c546c385a2c8ab2e575e2458f3" "397313302d6d65176ee9ddfac5341ce8b5f57167135bd09ad3549d5754002218" "58166a2630f7e2463406812113c4a704fda3c392dab3bbbcd4c88db860e9002b" "92e877e340e4a561f353d006d9c3f5ffc52523c6a52cda6e61da06850e3b3861" "0b3254bdeb1631aaedf73143e5080d2cb3013824c4662a4d8134f662716e1778" "e8e859ddeee2d8badf2f8944f3ae84247d8fa508732276c10578577ff09063ca" "abecf8b6853573d0f7553c79887d66408235f8c863b4db5add5c580769e22743" "eda38eb7c4923405333c16071a5f0f869735d1c029fd86eabac0b964e8a76c54" "34c190be183b2307c39ba85441608aed7d00a1cb6ea5510b8ca9bc74ecc06644" "3bd1027e014d8e9f2591c122299af7af79475f6405edb4ee51ddd0201407e8c9" "da99853c66f57938a2c5e9f3c703e980db2813bfb309efaf97928a38f2a4bca1" "1ab471764f4a1684b74afc9f234ba261671072ab1673d5160e1cc083d45592a6" "c5789c18d92b0387269480ab7d91cad1c1f3ed85301f24b902c2d8e036219a02" "6240cf19ad64dbb83ce615a5710aad2c90c58505ddeaa1ecb2dedf837ce73a74" "547581a21ad562598c57d6ac84e9e575cf9f273cca9d0ac30fa15127017e1e60" "1a1136fdf0762143418319c582646e1c7bcb1913b535a75c7353578e76c11399" "4436995cf45d544a68fd9c571786fed96578b5d99314e77e2f6e0e663ee53949" "bf0068e6a49a6c491fe8e85e7534557b73b1cf0c084ad4fc590217b1bae7c066" "440bda4e3b9c5c50e2779dd6f5676703fc355359e75f5916b12ed9aac3956a1c" "57f96b03e3abb26948c336e0577439edb7b879e89368406736dcbce812fef327" "94f6be0791cdec23952cc4c064eba32bb7c15e6f89ed76845044134f01c25894" "72a07f02740329d23fd3322cb8ed6b8a5574a3fbe07703e70738eda0ee7f39c2" "148f0a5b6224171762291a341b06cab55bd10bca10286d3366f44a74fd7ed2a2" "fca543de4a99544159c37bc86eb9c53509414982c573d73f15bf04ad6be02a3d" "4a4bf2300b5170ac1fdc4ecc02e7a6e31e4e2a7f4a6ac3c06f1d1fada8f9a56e" "296da7c17c698e963c79b985c6822db0b627f51474c161d82853d2cb1b90afb0" "bb05c5bad62951d74f5f04ad31bcd637bc557f0fe4b86e59599b221e8287fb11" "2d8d5d69e1ddde84f16f1ea06c212e0979799809d4e3589a0356c6c198bd9a52" "ce8a12bc77382dfac69f5d948eeef5b6076f120a3911df439c6ad590f3a8fabf" "020f11a75787d80748b37baccce70eb8a038b4abc76ed0aa46c41d2590a6ff71" "b2c9efdd2e3717ba2602c2c676a7723f206febab1b3d7983154df58d76cf30b2" "28f62c7fde6a5485ac60c8edf1471f55a833747da19c72b14aad0c28edc6782e" "f9e9d1cb077bc3c7d7b440f546177184357d364d43e217250ddcc836aadb46e3" "3adf163e44b5908ff2711a490dd2f1eb4faadb11fd7e8cd0d1a355cde2fdcb71" "384b1ac597adca9136c7a0d53cf20240587d1b163fb8ae380ac1249c257bc0d8" "4bf660d38c3854060ab9a3dfaa606cdb251435ff6cba3fc9f9fdb1636a4ac511" "350403fc515c00e85a03a9dcd228e5d81be6d49dae114d560056237c4144dd36" "f8a7e502e92ec89aca3028bd17647c976a47613953ff2547aee7a50ae61b2cfc" "b5991af461e040275f2b3cb048e46b6b0ca8a2e714945c7744e065b8c23f667d" "5d9e717bedc3e5a16eb471961cafd5bd822ae8be39f6ae0aaa6efee8fa6c96c6" "cc07305c7c0ed8d6cc1a3b1837b04c6dba785a2e887606ca1bc5a4817f5621c3" default))
 '(delete-auto-save-files nil)
 '(delete-old-versions 'other)
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(make-backup-file-name-function 'ignore)
 '(make-backup-files nil)
 '(mouse-wheel-follow-mouse nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount '(15))
 '(package-selected-packages '(rainbow-delimiters highlight-numbers))
 '(version-control nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'default-frame-alist '(font . "AcPlus IBM BIOS-11"))
(set-face-attribute 'default t :font "AcPlus IBM BIOS-11")
;(add-to-list 'default-frame-alist '(font . "Fira Code Semibold-11"))
;(set-face-attribute 'default t :font "Fira Code Semibold-11")
;(add-to-list 'default-frame-alist '(font . "Consolas-11"))
;(set-face-attribute 'default t :font "Consolas-11")

(defun post-load-stuff ()
  (interactive)
  (menu-bar-mode -1)
  (maximize-frame)
)
(add-hook 'window-setup-hook 'post-load-stuff t)
