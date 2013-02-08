<?php

/**
 * @file CamhrpThemePlugin.inc.php
 *
 * Copyright (c) 2011, MSB
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class CamhrpThemePlugin
 * @ingroup plugins_themes_camhrp
 *
 * @brief "Camhrp" theme plugin
 */

// $Id$


import('classes.plugins.ThemePlugin');

class CamhrpThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'CamhrpThemePlugin';
	}

	function getDisplayName() {
		return 'Camhrp Theme';
	}

	function getDescription() {
		return 'WHO Western Pacific Region layout';
	}

	function getStylesheetFilename() {
		return 'camhrp.css';
	}
	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
