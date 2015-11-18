<?php

function webfactp_install_tasks() {
  $task['machine_name'] = array(
    'display_name' => st('Set theme'),
    'display' => TRUE,
    'type' => 'normal',
    'run' => INSTALL_TASK_RUN_IF_REACHED,
    'function' => 'webfactp_set_theme',
  );
  return($task);
}

function webfactp_set_theme() {
  theme_enable(array('bootstrap'));
  $enable = array(
    'theme_default' => 'webfact_theme',
    'admin_theme' => 'seven',
  );
  theme_enable($enable);

  foreach ($enable as $var => $theme) {
    if (!is_numeric($var)) {
      variable_set($var, $theme);
    }
  }
  // Disable the default Bartik theme
  theme_disable(array('bartik'));

/*
  // disable search block
  $blocks = array(
    array(
      'module' => 'search',
      'delta' => 'form',
      'theme' => $default_theme,
      'status' => 0,    // disable
      'weight' => -1,
      'region' => 'sidebar_first',
      'pages' => '',
      'cache' => -1,
    ),
  );
  $query = db_insert('block')->fields(array('module', 'delta', 'theme', 'status', 'weight', 'region', 'pages', 'cache'));
  foreach ($blocks as $block) {
    $query->values($block);
  }
  $query->execute();
*/

  // settings: performance
  variable_set('page_compression', '1');
  variable_set('preprocess_css', '1');
  variable_set('preprocess_js', '1');
  variable_set('cache', 1);

  variable_set('jquery_update_compression_type', 'min');
  variable_set('jquery_update_jquery_cdn', 'google');

  // add a front page node
  $node = new stdClass();
  $node->type = 'page';
  $node->uid = 1;
  $node->status = 1;
  $node->title = 'Welcome';
  $node->path = array('alias' => 'welcome');
  $node->language = LANGUAGE_NONE;
  $node->body[$node->language][0]['value']='The webfactory allows creation of micro websites thanks to Docker and Drupal. Visit /admin/config/development/webfact to configure and /websites for a list of containers.';
  node_save($node);
  variable_set('site_frontpage', 'node/' . $node->nid);   // front page is the node added above


  // other settings
  variable_set('file_private_path', '/var/lib/drupal-private');
  variable_set('file_temporary_path', '/tmp');
  variable_set('webfact_msglevel2', '1');
  variable_set('webfact_msglevel3', '1');
  variable_set('webfact_fserver', 'webfact.docker');
  variable_set('webfact_dserver', 'unix:///var/run/docker.sock');
  variable_set('webfact_rproxy', 'nginx');
  variable_set('webfact_data_volume', '1');
  variable_set('webfact_www_volume', '1');
  variable_set('webfact_rebuild_backups', '0');

  // disabled unneeded modules
  module_disable(array('rdf', 'color', 'overlay', 'devel'));

  // can enable the feature here, but not in the .info. strange
  module_enable(array('webfact_content_types'));

  // add a template
  $node = new stdClass();
  $node->type = 'template';
  $node->uid = 1;
  $node->title = 'Plain Drupal7';
  $node->language = LANGUAGE_NONE;
  $node->body[$node->language][0]['value']='Plain Drupal 7';
  $node->field_docker_image['und'][0]['value'] = 'boran/drupal';
  node_save($node);
  $templateid = $node->nid;

  // add a website
  $node = new stdClass();
  $node->type = 'website';
  $node->uid = 1;
  $node->title = 'vanilla';
  $node->language = LANGUAGE_NONE;
  $node->body[$node->language][0]['value']='Example website container called vanilla using the boran/drupal image from the template Plain Drupal7';
  $node->field_hostname['und'][0]['value'] = 'vanilla';
  $node->field_template['und'][0]['target_id'] = $templateid;      // link to template
  $node->field_docker_ports['und'][0]['value'] = '80:8001';        // website will be visble on port 8001. TODO: this value is *not* saved
  //$node->field_docker_image['und'][0]['value'] = 'boran/drupal'; // could directly specify the image
  node_save($node);

  // add a D8 template
  $node = new stdClass();
  $node->type = 'template';
  $node->uid = 1;
  $node->title = 'Plain Drupal8';
  $node->language = LANGUAGE_NONE;
  $node->body[$node->language][0]['value']='Plain Drupal 8';
  $node->field_docker_image['und'][0]['value'] = 'boran/drupal';
  $node->field_docker_environment['und'][]['value'] = 'DRUPAL_VERSION=drupal-8';
  node_save($node);
  $templateid = $node->nid;

  // add a D8 website
  $node = new stdClass();
  $node->type = 'website';
  $node->uid = 1;
  $node->title = 'vanilla8';
  $node->language = LANGUAGE_NONE;
  $node->body[$node->language][0]['value']='Example website called vanilla8 from the template Plain Drupal8';
  $node->field_hostname['und'][0]['value'] = 'vanilla8';
  $node->field_template['und'][0]['target_id'] = $templateid;      // link to template
  $node->field_docker_ports['und'][0]['value'] = '80:8002';        // website will be visble on port 8001. TODO: this value is *not* saved
  node_save($node);

}


/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function webfactp_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
}

?>
