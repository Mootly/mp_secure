<?php
/**
  * Handle element locking for objects.
  * Implements mpi_secure.
  *
  * Public Properties:
  *   None.
  * Methods:
  * @method bool              __construct(object)
  * @method string|bool       checklock(string)
  * @method array|bool        listlock(string)
  * @method array|bool        listsecure(string)
  * @method bool              lock(string)
  * @method array|bool        unlock(string)
  * @method array             secure(string)
  * @method bool              secure4prod()
  *
  * @copyright 2021-2022 Mootly Obviate
  * @package   mooseplum
  * @version   0.1.0
  * --- Revision History ------------------------------------------------------ *
  * 2022-07-01 | New PHP 8.0 version ready.
  * --------------------------------------------------------------------------- */
namespace mpc;
class mpc_secure implements mpi_secure {
  protected $iName;
  protected $classRef;
  protected $locked           = array();
  protected $secured          = array();
  protected $err              = null;
  # *** END - property assignments ---------------------------------------------- *
  #
  # *** BEGIN constructor ------------------------------------------------------- *
  /**
   * Constructor
   * Just bind our error reporting class for now.
   *
   * @param  bool    $pLock
   * @return bool
   */
  /* !!!!!!!!!! ADD SUCCESS ENTRY TO LOG FOR INSTANTIATION !!!!!!!!!! */
  public function __construct(mpc_errors $pErrors) {
    $this->classRef = bin2hex(random_bytes(8)).'::'.get_class();
    $this->err      = $pErrors;
  }
# *** END - constructor ------------------------------------------------------- *
#
# *** BEGIN checklock --------------------------------------------------------- *
  public function checklock(string $pProp) : string|bool {
    if (in_array($pProp, $this->secured)) {
      $tReturn = 'secured';
    } elseif (in_array($pProp, $this->locked)) {
      $tReturn = 'locked';
    } else {
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - checklock --------------------------------------------------------- *
#
# *** BEGIN listlock ---------------------------------------------------------- *
  public function listlock(string $pFilter='') : array|bool {
    if (!(count($this->locked)) || (in_array($this->classRef, $this->secured))) {
      $tReturn = false;
    } elseif ($pFilter) {
      $tFilter = preg_quote($pFilter);
      $tReturn = preg_grep('/^'.$tFilter.'.*/', $this->locked);
      $tReturn = (count($tReturn)) ? $tReturn : false;
    } elseif (in_array($this->classRef, $this->locked)) {
      $tReturn = false;
    } else {
      $tReturn = $this->locked;
     }
    return $tReturn;
  }
# *** END - listlock ---------------------------------------------------------- *
#
# *** BEGIN listsecure -------------------------------------------------------- *
  public function listsecure(string $pFilter='') : array|bool {
    if (!(count($this->secured)) || (in_array($this->classRef, $this->secured))) {
      $tReturn = false;
    } elseif ($pFilter) {
      $tFilter = preg_quote($pFilter);
      $tReturn = preg_grep('/^'.$tFilter.'.*/', $this->secured);
      $tReturn = (count($tReturn)) ? $tReturn : false;
    } elseif (in_array($this->classRef, $this->locked)) {
      $tReturn = false;
    } else {
      $tReturn = $this->secured;
     }
    return $tReturn;
  }
# *** END - listsecure -------------------------------------------------------- *
#
# *** BEGIN lock -------------------------------------------------------------- *
# You can secure a lock, but not lock a secure.
  public function lock(string $pProp) : bool {
    if (in_array($pProp, $this->secured)) {
      $this->err->setStatus('mpe_secure', $pProp);
      $tReturn = false;
    } elseif (in_array($pProp, $this->locked)) {
      $tReturn = true;
    } else {
      $this->locked[] = $pProp;
      $tReturn = true;
    }
    return $tReturn;
  }
# *** END - lock -------------------------------------------------------------- *
#
# *** BEGIN unlock ------------------------------------------------------------ *
  public function unlock(string $pProp) : bool  {
    if (in_array($pProp, $this->secured)) {
      $this->err->setStatus('mpe_secure', $pProp);
      $tReturn = false;
    } elseif(in_array($pProp, $this->locked)) {
      $tKey = array_search($pProp, $this->locked);
      unset($this->locked[$tKey]);
      $tReturn = true;
    } else {
      $this->err->setStatus('mpe_null', $pProp);
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - unlock ------------------------------------------------------------ *
#
# *** BEGIN secure ------------------------------------------------------------ *
# You can secure a lock, but not lock a secure.
  public function secure(string $pProp) : bool  {
    if (!in_array($pProp, $this->secured)) { $this->secured[] = $pProp; }
    return true;
  }
# *** END - secure ------------------------------------------------------------ *
#
# *** BEGIN secure4prod ------------------------------------------------------- *
# You can secure a lock, but not lock a secure.
  public function secure4prod() : bool  {
    if (!in_array($this->classRef, $this->secured)) { $this->secured[] = $this->classRef; }
    return true;
  }
# *** END - secure4prod ------------------------------------------------------- *
}
// End mpc_secure ------------------------------------------------------------- *
