<?php
/**
  * Methods for securing properties for data storage and configuration classes.
  * There are three methods to:
  * - lock properties from editing
  * - secure properties so they cannot be unlocked
  * - unlock properties
  * Each takes one argument regarding what to (un)lock.
  * Recommended method: Record locked items using a pseudo-namespace.
  * Example: mpo_menus::main_nav::home_link
  * This allows a single instance of the object to be used for all locks.
  *
  * @copyright 2021-2022 Mootly Obviate
  * @package   moosepress
  * --- Revision History ------------------------------------------------------ *
  * 2022-01-01 | New version.
  * --------------------------------------------------------------------------- */
interface mpi_secure {
# *** BEGIN check ------------------------------------------------------------- *
/**
  * Check whether a given element is locked.
  *
  * @param string   $pProp   (optional) Specific property to be checked.
  * @return string|bool
  */
  public function checklock(string $pProp) : string|bool;
# *** END - check ------------------------------------------------------------- *
#
# *** BEGIN lock -------------------------------------------------------------- *
/**
  * Lock elements from further updates.
  * Instance should still allow new elements to be added.
  *
  * @param string   $pProp   (optional) Specific property to be locked.
  * @return bool
  */
  public function lock(string $pProp) : bool;
# *** END - lock -------------------------------------------------------------- *
#
# *** BEGIN unlock ------------------------------------------------------------ *
/**
  * unlock  - Unlock pseudo-elements for updates.
  * Method should throw error if element is secured.
  *
  * @param string   $pProp   (optional) Specific property to be locked.
  * @return bool
  */
  public function unlock(string $pProp) : bool;
# *** END - unlock ------------------------------------------------------------ *
#
# *** BEGIN secure ------------------------------------------------------------ *
/**
  * Lock elements from further updates.
  * Same as lock, but cannot be unlocked again.
  * Instance should still allow new elements to be added.
  *
  * @param string   $pProp   (optional) Specific property to be locked.
  * @return bool
  */
  public function secure(string $pProp) : bool;
# *** END - secure ------------------------------------------------------------ *
}
// End mpc_paths -------------------------------------------------------------- *
