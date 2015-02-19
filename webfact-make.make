; Drush make file

core = 7.x
api = 2

; Core project
; ------------
; In order for your makefile to generate a full Drupal site, you must include
; a core project. This is usually Drupal core, but you can also specify
; alternative core projects like Pressflow. Note that makefiles included with
; install profiles *should not* include a core project.

; Either latest 7, specific or dev version
projects[drupal][version] = 7.x
;projects[drupal][version] = 7.22
;projects[] = drupal

# why does this not work?
;defaults[projects][subdir] = "contrib"

; Profiles
projects[webfactp][type] = "profile"
projects[webfactp][subdir] = ""
;projects[webfactp][download][type] = "file"
;projects[webfactp][download][url] = "webfactp.tgz"
; a bit recursive: we get outselves :-)
projects[webfactp][download][type] = "git"
projects[webfactp][download][url] = "git://github.com/Boran/webfact-make.git"


; Modules
; --------
projects[admin_menu][type] = "module"
projects[admin_menu][subdir] = "contrib"
projects[features][type] = "module"
projects[features][subdir] = "contrib"
projects[advanced_help][type] = "module"
projects[advanced_help][subdir] = "contrib"
projects[entity][type] = "module"
projects[entity][subdir] = "contrib"
projects[entityreference][type] = "module"
projects[entityreference][subdir] = "contrib"
;projects[field_image][type] = "module"
;projects[field_image][subdir] = "contrib"
projects[field_default_token][type] = "module"
projects[field_default_token][subdir] = "contrib"

projects[ctools][type] = "module"
projects[ctools][subdir] = "contrib"
projects[devel][type] = "module"
projects[devel][subdir] = "contrib"
projects[token][type] = "module"
projects[token][subdir] = "contrib"

;projects[link][type] = "module"
;projects[link][subdir] = "contrib"
;projects[i18n][type] = "module"
;projects[i18n][subdir] = "contrib"
;projects[backup_migrate][type] = "module"
;projects[backup_migrate][subdir] = "contrib"

projects[jquery_update][type] = "module"
projects[jquery_update][subdir] = "contrib"

projects[libraries][type] = "module"
projects[libraries][subdir] = "contrib"

;projects[ckeditor][type] = "module"

projects[views][type] = "module"
projects[views][subdir] = "contrib"
;projects[views_bulk_operations][type] = "module"
;projects[views_bulk_operations][subdir] = "contrib"
;projects[webform][type] = "module"
;projects[webform][subdir] = "contrib"
;projects[colorbox][type] = "module"
;projects[colorbox][subdir] = "contrib"
;projects[imce][type] = "module"
;projects[imce][subdir] = "contrib"
;projects[reroute_email][type] = "module"
;projects[reroute_email][subdir] = "contrib"
;projects[rules][type] = "module"
;projects[rules][subdir] = "contrib"
projects[variable][type] = "module"
projects[variable][subdir] = "contrib"
projects[strongarm][type] = "module"
projects[strongarm][subdir] = "contrib"
projects[date][type] = "module"
projects[date][subdir] = "contrib"
projects[field_group][type] = "module"
projects[field_group][subdir] = "contrib"

; to enable template sharing/copying
;projects[uuid][type] = "module"
;projects[uuid][subdir] = "contrib"
;projects[clone][type] = "module"
;projects[clone][subdir] = "contrib"
;projects[node_export][type] = "module"
;projects[node_export][subdir] = "contrib"

; how to install a drush extension?
;projects[composer][type] = "module"
;projects[composer][download][type] = "git"
;projects[composer][download][branch] = "8.x-1.x"
;projects[composer][download][url] = "http://git.drupal.org/project/composer.git"
projects[composer_manager][type] = "module"
projects[composer_manager][subdir] = "contrib"


; webfactory
projects[webfact][type] = "module"
projects[webfact][subdir] = "custom"
projects[webfact][download][type] = "git"
projects[webfact][download][working-copy] = "true"
projects[webfact][download][url] = "git://github.com/Boran/webfact.git"

projects[webfact_content_types][type] = "module"
projects[webfact_content_types][subdir] = "custom"
projects[webfact_content_types][download][type] = "git"
projects[webfact_content_types][download][working-copy] = "true"
projects[webfact_content_types][download][url] = "git://github.com/Boran/webfact_content_types.git"


; Themes
; --------
projects[bootstrap][version] = 3.0
projects[bootstrap][type] = "theme"
projects[bootstrap][subdir] = "contrib"

;Theme helpers
; --------
projects[views_bootstrap][type] = "module"
projects[views_bootstrap][subdir] = "contrib"

; Libraries
; ---------
;libraries[ckeditor][type] = "libraries"
;libraries[ckeditor][download][type] = "file"
;libraries[ckeditor][download][url] = "https://github.com/ckeditor/ckeditor-releases/archive/latest/full.zip"
;libraries[colorbox][type] = "libraries"
;libraries[colorbox][download][type] = "file"
;libraries[colorbox][download][url] = "https://github.com/jackmoore/colorbox/archive/master.zip"

