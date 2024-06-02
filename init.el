;;; package --- Summary

;;; Commentary:

;;; Code:

;; Set Package Mirrors
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

;; Installed Packages
(require 'package)
(require 'ein)
(require 'color)
(require 'company)
(require 'flycheck)
(require 'smartparens)
(require 'elcord)
(require 'ox-latex)
(require 'ob-shell)
(require 'pyvenv)

;(elpy-enable)

;; Local Appearances and Functionality
(set-foreground-color "white")
(set-background-color "black")
(set-face-attribute 'default nil :height 150)
(setq inhibit-startup-screen t)
(setq comint-prompt-read-only t)

(setq compilation-window-height 1)
(set-face-attribute 'comint-highlight-prompt nil :weight 'semibold :foreground "#659bff" :inherit nil)
(window-divider-mode t)
;(set-default 'truncate-lines t)
(setq window-divider-default-right-width 5)
(setq revert-without-query '("\\.pdf"))
;;(setq org-export-with-section-numbers 0)
(defalias 'yes-or-no-p 'y-or-n-p)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'pdf-view-mode-hook (lambda () (auto-revert-mode 1)))

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-auto-revert-mode 1)
(load-theme 'atom-one-dark t)
(setenv "WORKON_HOME" "~/.virtualenvs/python-venv")
(pyvenv-mode)
(pyvenv-activate  "~/.virtualenvs/python-venv/")
(yas-global-mode)

(defun toggle-window-split ()
  (interactive) ;;Toggle window from horizontal to vertical split
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-h C-r r") 'load-file)

(defun my-c++-mode-setup ()
  "Setup for `c++-mode`."
  (hs-minor-mode 1)                     ; Enable hs-minor-mode
  (local-set-key (kbd "C-c C-f") 'hs-hide-block)   ; Bind key to hide block
  (local-set-key (kbd "C-c C-g") 'hs-show-block))  ; Bind key to show block

(add-hook 'c++-mode-hook 'my-c++-mode-setup)

;; Orgmode Configuration
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq-default org-src-fontify-natively t)
(setq org-export-dispatch-use-expert-ui t)
(setq org-src-tab-acts-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-edit-src-content-indentation 4)
(setq-default org-startup-indented nil)
(setq org-src-preserve-indentation t)
(setq confirm-kill-processes nil)
(setq-default tab-width 4)
(setq-default org-hide-emphasis-markers t)
(setq-default org-pretty-entities t)
(setq-default org-pretty-entities-include-sub-superscripts t)
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
(setq org-latex-src-block-backend 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))


(defun my/org-export-to-pdf-and-open-in-vertical-split ()
  "Export the current Org file to PDF and open the PDF in a vertical split."
  (interactive)
  (let ((pdf-file (concat (file-name-sans-extension (buffer-file-name)) ".pdf")))
    (org-latex-export-to-pdf)
    (find-file-other-window pdf-file)))


(define-key org-mode-map (kbd "C-c C-p") 'my/org-export-to-pdf-and-open-in-vertical-split)
(global-set-key (kbd "C-x |") 'toggle-window-split)

;; Ivy Counsel Swiper Autocompletion
(ivy-mode 1)
(setq-default ivy-use-virtual-buffers t)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'swiper-isearch-backward)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-set-key (kbd "C-c b") 'counsel-bookmark)
(global-set-key (kbd "M-s s") 'shell)
(global-set-key (kbd "C-c c") 'compile)

;; Elcord Mode
(elcord-mode)

(smartparens-global-mode 1)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)

(global-flycheck-mode)
(setq-default flycheck-indication-mode 'left-margin)
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode)
  (add-hook 'flycheck-mode-hook #'flycheck-set-indication-mode)
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
  (add-hook 'flycheck-mode-hook #'flycheck-popup-tip-mode)
  )

(setq display-buffer-alist
      (append display-buffer-alist
              '(("\\*compilation\\*"
                 (display-buffer-no-window)
                 (allow-no-window . t)))))

(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.33)))


(global-company-mode)
(with-eval-after-load 'company
  (setq company-minimum-prefix-length 3)
  (setq company-selection-wrap-around t)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ein:output-area-inlined-image-properties nil)
 '(ein:output-area-inlined-images t)
 '(org-babel-load-languages
   '((emacs-lisp . t)
	 (C . t)
	 (R . t)
	 (python . t)
	 (calc . t)
	 (clojure . t)
	 (css . t)
	 (ditaa . t)
	 (fortran . t)
	 (gnuplot . t)
	 (haskell . t)
	 (julia . t)
	 (js . t)
	 (ruby . t)
	 (latex . t)
	 (shell . t)))
 '(package-selected-packages
   '(magit ess-r-insert-obj ess-view ess-smart-underscore ess-smart-equals ess-R-data-view ess-view-data ess yasnippet-snippets yasnippet-classic-snippets yasnippet org-modern counsel ivy projectile atom-one-dark-theme smartparens flycheck-popup-tip flycheck-pos-tip flycheck irony company elcord pdf-tools pyvenv ein))
 '(warning-suppress-types '(((unlock-file)) ((unlock-file)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-block ((t (:background "#1D1D1D" :extend t)))))

(provide 'init)
;;; init.el ends here
