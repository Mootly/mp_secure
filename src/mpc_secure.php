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
  * @copyright 2021-2023 Mootly Obviate
  * @package   mooseplum/php_classes/secure
  * @version   1.0.0
  * --- Revision History ------------------------------------------------------ *
  * 2025-04-17 | Fixed typo in comments.
  * 2023-05-12 | 1.0 ready.
  * --------------------------------------------------------------------------- */
namespace mpc;
class mpc_secure implements mpi_secure {
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
  public function __construct(mpc_errors $pErrors) {
    $this->err      = $pErrors;
    $this->classRef = bin2hex(random_bytes(8)).'::'.get_class();
    $this->err->setStatus('none', $this->classRef);
  }
# *** END - constructor ------------------------------------------------------- *
#
# *** BEGIN checklock --------------------------------------------------------- *
  public function checklock(string $pProp) : string|bool {
    $tMethod        = $this->classRef.'::'.__METHOD__;
    $tCount         = func_num_args();
    $tError         = $this->checkArgs($pProp, $tCount);
    if ($tError == 'none') {
      if (in_array($pProp, $this->secured)) {
        $tReturn = 'secured';
      } elseif (in_array($pProp, $this->locked)) {
        $tReturn = 'locked';
      } else {
        $tReturn = false;
      }
    } else {
      $this->err->setStatus($tError, $tMethod);
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - checklock --------------------------------------------------------- *
#
# *** BEGIN listlock ---------------------------------------------------------- *
  public function listlock(string $pFilter='') : array|bool {
    $tMethod        = $this->classRef.'::'.__METHOD__;
    $tCount         = func_num_args();
    $tError         = $this->checkArgs($pFilter, $tCount);
    if ($tError == 'none') {
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
    } else {
      $this->err->setStatus($tError, $tMethod);
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - listlock ---------------------------------------------------------- *
#
# *** BEGIN listsecure -------------------------------------------------------- *
  public function listsecure(string $pFilter='') : array|bool {
    $tMethod        = $this->classRef.'::'.__METHOD__;
    $tCount         = func_num_args();
    $tError         = $this->checkArgs($pFilter, $tCount);
    if ($tError == 'none') {
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
    } else {
      $this->err->setStatus($tError, $tMethod);
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - listsecure -------------------------------------------------------- *
#
# *** BEGIN lock -------------------------------------------------------------- *
# You can secure a lock, but not lock a secure.
  public function lock(string $pProp) : bool {
    $tMethod        = $this->classRef.'::'.__METHOD__;
    $tCount         = func_num_args();
    $tError         = $this->checkArgs($pProp, $tCount);
    if ($tError == 'none') {
      if (in_array($pProp, $this->secured)) {
        $this->err->setStatus('mpe_secure', $pProp);
        $tReturn = false;
      } elseif (in_array($pProp, $this->locked)) {
        $tReturn = true;
      } else {
        $this->locked[] = $pProp;
        $tReturn = true;
      }
    } else {
      $this->err->setStatus($tError, $tMethod);
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - lock -------------------------------------------------------------- *
#
# *** BEGIN unlock ------------------------------------------------------------ *
  public function unlock(string $pProp) : bool  {
    $tMethod        = $this->classRef.'::'.__METHOD__;
    $tCount         = func_num_args();
    $tError         = $this->checkArgs($pProp, $tCount);
    if ($tError == 'none') {
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
    } else {
      $this->err->setStatus($tError, $tMethod);
      $tReturn = false;
    }
    return $tReturn;
  }
# *** END - unlock ------------------------------------------------------------ *
#
# *** BEGIN secure ------------------------------------------------------------ *
# You can secure a lock, but not lock a secure.
  public function secure(string $pProp) : bool  {
    $tMethod        = $this->classRef.'::'.__METHOD__;
    $tCount         = func_num_args();
    $tError         = $this->checkArgs($pProp, $tCount);
    if ($tError == 'none') {
      if (!in_array($pProp, $this->secured)) { $this->secured[] = $pProp; }
      $tReturn = true;
    } else {
      $this->err->setStatus($tError, $tMethod);
      $tReturn = false;
    }
    return $tReturn;

  }
# *** END - secure ------------------------------------------------------------ *
#
# *** BEGIN secure4prod ------------------------------------------------------- *
# You can secure a lock, but not lock a secure.
  public function secure4prod() : bool  {
    if (!in_array($this->classRef, $this->secured)) { $this->secured[] = $this->classRef; }
    return true;
  }
#
# *** BEGIN checkArgs --------------------------------------------------------- *
# All methods except secure4prod expect a single string.
# This checks the count for each to reduce redundancy.
# Return values from mpc_error codes.
# Only returned fail condition should be mpe_param04b, rest should abend.
# They are just here for CYA.
private function checkArgs(string $pProp, int $pCount) : string  {
  $tReturn          = 'none';
  if ($pCount < 1) {
    $tReturn        = 'mpe_param03';
  } elseif (!is_string($pProp)) {
    $tReturn        = 'mpe_param01';
  } elseif ($pCount > 1) {
    $tReturn        = 'mpe_param04a';
  }
  return $tReturn;
}
# *** END - secure4prod ------------------------------------------------------- *
}
// End mpc_secure ------------------------------------------------------------- *
