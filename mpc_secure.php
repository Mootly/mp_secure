<?php
/**
  * Handle element locking for objects.
  * Implements mpi_secure.
  *
  * Public Properties:
  *   None.
  * Methods:
  * @method bool              __construct(array, bool, int)
  * @method string|bool       check(string)
  * @method bool              checklock(string)
  * @method array|bool        unlock(string)
  * @method array             secure(string)
  * @method bool              addStatusCodes(array, bool)
  *
  * @copyright 2017-2022 Mootly Obviate
  * @package   moosepress
  * --------------------------------------------------------------------------- */
class mpc_secure implements mpi_secure {
  protected $iName;
  protected static $iCount    = 0;
  protected $locked           = array();
  protected $secured          = array();
  protected $err              = NULL;
# *** END - property assignments ---------------------------------------------- *
#
# *** BEGIN constructor ------------------------------------------------------- *
/**
  * Constructor
  * To lock, instantiate with true.
  * If we do a general lock, values can be added but not changed.
  * Locked status codes already in mps_errors, so don't have to add
  *
  * @param  bool    $pLock
  * @return bool
  */
  public function __construct(mpc_errors $pErrors, string $pProp='', bool $pLock=false) {
    $this->iName              = get_class().'_'.self::$iCount++;
    $this->err                = $pErrors;
    if ($pProp) {$this->locked[$pProp] = $pLock; }
    return true;
  }
# *** END - constructor ------------------------------------------------------- *
#
# *** BEGIN check ------------------------------------------------------------- *
public function checklock(string $pProp) : string|bool {
  $tReturn = false;
  if (!empty($this->locked[$pProp]))  { $tReturn = 'locked'; }
  if (!empty($this->secured[$pProp])) { $tReturn = 'secured'; }
  return $tReturn;
}
# *** END - check ------------------------------------------------------------- *
#
# *** BEGIN lock -------------------------------------------------------------- *
# No need to check, just set it.
public function lock(string $pProp) : bool {
  $this->locked[$pProp]   = true;
  $this->err->setStatus('none', $this->iName.'::'.__METHOD__);
  return true;
}
# *** END - lock -------------------------------------------------------------- *
#
# *** BEGIN unlock ------------------------------------------------------------ *
public function unlock(string $pProp) : bool  {
  $tMethod        = $this->iName.'::'.__METHOD__;
  if (!empty($this->secured[$pProp])) {
    $this->err->setStatus('mpe_secure', $tMethod);
  } elseif(!empty($this->locked[$pProp])) {
    unset($this->locked[$pProp]);
    $this->err->setStatus('none', $tMethod);
  } else {
    $this->err->setStatus('mpe_null', $tMethod);
  }
  return $this->err->getStatus()['success'];
}
# *** END - unlock ------------------------------------------------------------ *
#
# *** BEGIN secure ------------------------------------------------------------ *
# No need to check, just set it.
public function secure(string $pProp) : bool  {
  $this->secured[$pProp] = true;
  $this->err->setStatus('none', $this->iName.'::'.__METHOD__);
  return true;
}
# *** END - secure ------------------------------------------------------------ *
}
// End mpc_secure ------------------------------------------------------------- *
