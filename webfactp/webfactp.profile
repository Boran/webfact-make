<?php

#function webfactp_install_tasks() {
  #$task['machine_name'] = array(
  #  'display_name' => st('Set theme'),
  #  'display' => TRUE,
  #  'type' => 'normal',
  #  'run' => INSTALL_TASK_RUN_IF_REACHED,
  #  'function' => 'webfactb_set_theme',
  #);
#  return($task);
#}

/*
function webfactp_set_theme() {
  // Any themes without keys here will get numeric keys and so will be enabled,
  // but not placed into variables.
  $enable = array(
    'theme_default' => 'bootstrap',
    'admin_theme' => 'seven',
    //'zen'
  );
  theme_enable($enable);

  foreach ($enable as $var => $theme) {
    if (!is_numeric($var)) {
      variable_set($var, $theme);
    }
  }
  // Disable the default Bartik theme
  theme_disable(array('bartik'));
}
*/


/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
#function webfactp_form_install_configure_form_alter(&$form, $form_state) {
#  // Pre-populate the site name with the server name.
#  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
#}

?>
