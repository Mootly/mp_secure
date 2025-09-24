<?php
/**
  * Methods for securing properties for data storage and configuration classes.
  * There are methods to:
  * - lock properties from editing
  * - secure properties so they cannot be unlocked
  * - unlock properties
  * - check the status of properties
  * - generate a list of all current locks
  * - generate a list of all currently secured properties
  *
  * Locks stored as simple array of string values, so they must be unique.
  * Recommended method: Record locked items using a pseudo-namespace.
  * Examples:
  * - mpo_parts::main_body
  * - mpo_menus::main_nav::home_link
  * Autogeneration examples:
  * - _CLASS__.'::'.someProp
  * - __CLASS__.'::'.__METHOD__
  * - __CLASS__.'_'.self::$iCount++ (for multiple instances)
  *
  * @copyright 2021-2023 Mootly Obviate
  * @package   mooseplum/php_classes/secure
  * @version   1.0.1
  * --- Revision History ------------------------------------------------------ *
  * 2025-09-23 | Docs updates for deprecations.
  * 2025-04-17 | Fixed typo in comments.
  * 2023-05-12 | 1.0 ready.
  * --------------------------------------------------------------------------- */
namespace mpc;
interface mpi_secure {
# *** BEGIN checklock --------------------------------------------------------- *
/**
  * Check whether a given element is locked.
  *
  * @param string   $pProp    Specific property to be checked.
  * @return string|bool
  */
  public function checklock(string $pProp) : string|bool;
# *** END - checklock --------------------------------------------------------- *
#
# *** BEGIN listlock ---------------------------------------------------------- *
/**
  * List locked elements.
  * A search string may be provided to filter results against.
  * Use secure4prod to disable this method.
  *
  * @param string   $pFilter (optional) Beginning of identifiers to filter on.
  * @return array|bool
  */
  public function listlock(string $pFilter) : array|bool;
# *** END - listlock ---------------------------------------------------------- *
#
# *** BEGIN listsecure -------------------------------------------------------- *
/**
  * List all secured elements.
  * A search string may be provided to filter results against.
  * Use secure4prod to disable this method.
  *
  * @param string   $pFilter (optional) Beginning of identifiers to filter on.
  * @return array|bool
  */
  public function listsecure(string $pFilter) : array|bool;
# *** END - listsecure -------------------------------------------------------- *
#
# *** BEGIN lock -------------------------------------------------------------- *
/**
  * Lock elements from further updates.
  * Instance should still allow new elements to be added.
  *
  * @param string   $pProp    Specific property to be locked.
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
  * @param string   $pProp    Specific property to be locked.
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
  * @param string   $pProp    Specific property to be locked.
  * @return bool
  */
  public function secure(string $pProp) : bool;
# *** END - secure ------------------------------------------------------------ *
#
# *** BEGIN secure4prod ------------------------------------------------------- *
/**
  * Lock instances of this class down so that dev-only methods will not run.
  *
  * @return bool
  */
  public function secure4prod() : bool;
# *** END - secure4prod ------------------------------------------------------- *
}
// End mpi_secure ------------------------------------------------------------- *
