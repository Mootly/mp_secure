<?php
error_reporting(E_ALL);
require_once '../mp_errors/src/mpi_errors.php';
require_once '../mp_errors/src/mpc_errors.php';
require_once './src/mpi_secure.php';
require_once './src/mpc_secure.php';
function printResults($p_errObj) {
  $tCount = $p_errObj->getStatusCount();
  echo '<table class="error-report">';
  echo '<tr><th>#</th><th>success</th><th>code</th><th>source</th><th>severity</th><th>message</th></tr>';
  for ($x = 0; $x < $tCount; $x++) {
    $tError = $p_errObj->getStatus($x);
    $tSuccess = $tError['success'] ? 'true' : 'false';
    echo '<tr>';
    echo "<td>{$x}</td>";
    echo "<td>{$tSuccess}</td>";
    echo "<td>{$tError['code']}</td>";
    echo "<td>{$tError['source']}</td>";
    echo "<td>{$tError['severity']}</td>";
    echo "<td>{$tError['message']}</td>";
    echo '</tr>';
  }
  echo '</table>';
}
function printVariables($p_dataObj, $p_string = 'Result: ') {
  echo '<pre>', $p_string , var_export($p_dataObj), '</pre>';
}
function printError($p_err) { echo 'Error: ', $p_err->getMessage(); }
$mpo_secure         = false;
$t_status           = false;
$t_statusB          = false;
$t_statusC          = false;
$t_statusAll        = false;
function initDefaults() {
  $GLOBALS['mpo_secure']    = false;
  $GLOBALS['t_status']      = 'not run';
  $GLOBALS['t_statusAll']   = 'not run';
  $GLOBALS['t_statusB']     = 'not run';
}
?>
<html>
<head>
  <title>mpc_secure Test Page</title>
  <style type="text/css">
  body { background-color: #201920; color: #ffeeff; padding-bottom: 2.0em; }
  table.error-report { width: 100%; border-collapse: collapse; border: 1px solid #776677; }
  table.error-report th { text-align: left; font-weight: bold; padding: 0.25em; border-bottom: 1px solid #776677; }
  table.error-report td { padding: 0.25em; }
  h3 { margin-top: 3.0em; padding: 0.25em 0.125em 0.125em 0.125em; background-color: #302530; }
  h2 { margin-top: 2.0em; margin-bottom: 1.0em; padding: 0.5em 0.25em; background-color: #302530; border: 1px solid #776677; }
  a { color: #9999dd; }
  a:visited { color: #dd99dd; }
  .clean { background-color: #196019; padding: 0.125em 0.5em; }
  .alert { background-color: #605019; padding: 0.125em 0.5em; }
  .bug   { background-color: #601919; padding: 0.125em 0.5em; }
  </style>
</head>
<body>
<h1><code>mpc_secure</code> Test Page</h1>

<p>Last updated: October 27, 2022</p>

<h2>Sections</h2>

<p>Many of the tests of other methods will already occur during instantiation. Especially the addStatusCodes.</p>

<ul>
  <li><a href="#dependencies">Dependencies</a></li>
  <li><a href="#fix">Unexpected Behaviors</a></li>
</ul>
<ol>
  <li><a href="#instantiate">Instantiate</a></li>
  <li><a href="#check">check</a></li>
  <li><a href="#lock">lock</a></li>
  <li><a href="#unlock">unlock</a></li>
  <li><a href="#secure">secure</a></li>
  <li><a href="#listlock">listlock</a></li>
  <li><a href="#listsecure">listsecure</a></li>
  <li><a href="#secure4prod">secure4prod</a></li>
</ol>

<h2 id="dependencies">Dependencies</h2>

<ul>
  <li>mpc_errors</li>
</ul>

<h2 id="fix">Unexpected Behaviors</h2>

<p>None yet.</p>

<h2 id="instantiate">1. Instantiate</h2>

<ol>
  <li>Instantiate with no arguments</li>
  <li>Instantiate with bad object</li>
  <li>Instantiate with mpo_errors</li>
</ol>

<?php
  $mpo_errors       = false;
  $mpo_errors       = new \mpc\mpc_errors();
?>

<h3>Test 1.1: No Arguments</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
   initDefaults();
   try {
    $mpo_secure     = new \mpc\mpc_secure();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 1.2: Bad Object</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
  $t_badLock        = dir('./');
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 1.3: Correct Call with mpo_errors</h3>
<p class="clean">Good.</p>
<p>Pass a lock in and check it to make sure object is correctly instantiated. Results should be:</p>
<ul>
  <li>true</li>
  <li>'locked'</li>
  <li>false</li>
</ul>
<?php
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock('mpt_secure::test1.3');
    $t_statusB      = $mpo_secure->checklock('mpt_secure::test1.3');
    $t_statusC      = $mpo_secure->checklock('mpt_secure::null');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printVariables($t_statusB);
  printVariables($t_statusC);
  printResults($mpo_errors);
?>

<h2 id="check">2. checklock</h2>

<ol>
  <li>Check no arguments</li>
  <li>Check with bad argument - array</li>
  <li>Check with bar arguemnt - too many</li>
  <li>Check with undefined property</li>
  <li>Check with defined property</li>
</ol>

<h3>Test 2.1: No arguments</h3>
<p class="alert">Fatal error.</p>
<?php
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->checklock();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 2.2: Bad argument - array</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
  $t_badBool       = array('a','b');
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->checklock($t_badBool);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 2.3: Bad argument - too many</h3>
<p class="alert">Works. Only first argument is run.</p>
<?php
  $t_goodLock      = 'dummy::test';
  $t_badLock       = 'b';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $tDummy         = $mpo_secure->lock($t_goodLock);
    $t_status       = $mpo_secure->checklock($t_badLock, $t_goodLock);
    $t_statusA      = $mpo_secure->checklock($t_goodLock);
    $t_statusB      = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status,'Error bad, good: ');
  printVariables($t_statusA,'Error good: ');
  printVariables($t_statusB,'Error bad: ');
  printResults($mpo_errors);
?>

<h3>Test 2.4: Undefined Property</h3>
<p class="clean">Good.</p>
<p>Return false. An undefined property is by definition not locked.</p>
<?php
  $t_badLock       = 'undefined';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 2.5: Defined Property</h3>
<p class="clean">Good.</p>
<p>Test property is locked.</p>
<?php
  $t_goodLock      = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_goodLock);
    $t_status       = $mpo_secure->checklock($t_goodLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h2 id="lock">3. lock</h2>

<ol>
  <li>Check no arguments</li>
  <li>Check with bad argument - array</li>
  <li>Check with bad argument - int</li>
  <li>Check with bad argument - zero</li>
  <li>Check with bad argument - negative int</li>
  <li>Check with too many arguments</li>
  <li>Check with argument</li>
</ol>

<p>Reset object.</p>

<h3>Test 3.1: No Arguments</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
  $t_goodLock      = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 3.2: Bad Argument - Array</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
 $t_goodLock      = 'dummy::test';
 $t_badLock       = array('a','b');
 initDefaults();
 try {
   $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 3.3: Bad Argument - Integer</h3>
<p class="alert">Works. PHP converts to String. Allow.</p>
<?php
 $t_badLock         = 1;
 initDefaults();
 try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_badLock);
    $t_status       = $mpo_secure->checklock($t_badLock );
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value int(1): ');
  printResults($mpo_errors);
?>

<h3>Test 3.4: Bad Argument - Negative Integer</h3>
<p class="alert">Works. PHP converts to string. Allow.</p>
<?php
 $t_badLock         = -1;
 initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_badLock);
    $t_status       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value int(-1): ');
  printResults($mpo_errors);
?>

<h3>Test 3.5: Bad Argument - Zero</h3>
<p class="alert">Works. PHP converts to string. Allow.</p>
<?php
  $t_badLock        = 0;
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_badLock);
    $t_status       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value int(0): ');
  printResults($mpo_errors);
?>

<h3>Test 3.6: Bad Argument - Too Many</h3>
<p class="alert">Works. Only first argument is run. Allow.</p>
<?php
 $t_goodLock        = 'dummy::test';
 $t_badLock         = 'dummy::bad';
 initDefaults();
 try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_goodLock,$t_badLock);
    $t_status       = $mpo_secure->checklock($t_goodLock);
    $t_statusB       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value good: ');
  printVariables($t_statusB, 'Value bad: ');
  printResults($mpo_errors);
?>

<h3>Test 3.7: With Argument</h3>
<p class="clean">Good.</p>
<?php
  $t_goodLock       = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_goodLock);
    $t_status       = $mpo_secure->checklock($t_goodLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value good: ');
  printResults($mpo_errors);
?>

<h2 id="unlock">4. unlock</h2>

<p>Already resolved integer problems above, so not retesting here. Integers, including zero, are allowed.</p>
<ol>
  <li>Check no arguments</li>
  <li>Check with argument - not locked</li>
  <li>Check with argument - locked</li>
  <li>Check with bad argument - array</li>
  <li>Check with too many arguments</li>
  <li>Check with secured</li>
</ol>

<h3>Test 4.1: No Arguments</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->unlock();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 4.2: With Arguments - not locked</h3>
<p class="clean">Good.</p>
<p>Return false.</p>
<?php
  $t_goodLock       = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->unlock($t_goodLock);
    $t_status_b     = $mpo_secure->checklock($t_goodLock);

  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printVariables($t_status_b);
  printResults($mpo_errors);
?>

<h3>Test 4.3: With Arguments - locked</h3>
<p class="clean">Good.</p>
<?php
  $t_goodLock       = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_goodLock);
    $t_status_a       = $mpo_secure->unlock($t_goodLock);
    $t_status       = $mpo_secure->unlock($t_goodLock);
    $t_status_b     = $mpo_secure->checklock($t_goodLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status_a, 'Before: ');
  printVariables($t_status_b, 'After: ');
  printResults($mpo_errors);
?>

<h3>Test 4.4: Bad Argument - Array</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
  $t_goodLock       = 'a';
  $t_badLock        = array('a','b');
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_goodLock);
    $t_status       = $mpo_secure->unlock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 4.5: Too many arugments</h3>
<p class="alert">Works. Only first argument is run. Allow.</p>
<?php
  $t_goodLock       = 'a';
  $t_badLock        = 'b';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->lock($t_goodLock);
    $t_status       = $mpo_secure->unlock($t_goodLock, $t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printResults($mpo_errors);
?>

<h3>Test 4.6: Secured</h3>
<p class="clean">Good.</p>
<p>Return false. Lock is secured.
<?php
  $t_goodLock       = 'a';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_goodLock);
    $t_status       = $mpo_secure->unlock($t_goodLock);
    $t_status_b     = $mpo_secure->checklock($t_goodLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
  printVariables($t_status_b);
  printResults($mpo_errors);
?>

<h2 id="secure">5. secure</h2>

<ol>
  <li>Check no arguments</li>
  <li>Check with bad argument - array</li>
  <li>Check with bad argument - int</li>
  <li>Check with bad argument - zero</li>
  <li>Check with bad argument - negative int</li>
  <li>Check with too many arguments</li>
  <li>Check with argument</li>
</ol>

<p>Reset object.</p>

<h3>Test 5.1: No Arguments</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
  $t_goodLock      = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
?>

<h3>Test 5.2: Bad Argument - Array</h3>
<p class="alert">Fatal error. Correct.</p>
<?php
 $t_goodLock      = 'dummy::test';
 $t_badLock       = array('a','b');
 initDefaults();
 try {
   $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status);
?>

<h3>Test 5.3: Bad Argument - Integer</h3>
<p class="alert">Works. PHP converts to String. Allow.</p>
<?php
 $t_badLock         = 1;
 initDefaults();
 try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_badLock);
    $t_status       = $mpo_secure->checklock($t_badLock );
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value int(1): ');
?>

<h3>Test 5.4: Bad Argument - Negative Integer</h3>
<p class="alert">Works. PHP converts to string. Allow.</p>
<?php
 $t_badLock         = -1;
 initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_badLock);
    $t_status       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value int(-1): ');
?>

<h3>Test 5.5: Bad Argument - Zero</h3>
<p class="alert">Works. PHP converts to string. Allow.</p>
<?php
  $t_badLock        = 0;
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_badLock);
    $t_status       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value int(0): ');
?>

<h3>Test 5.6: Bad Argument - Too Many</h3>
<p class="alert">Works. Only first argument is run. Allow.</p>
<?php
 $t_goodLock        = 'dummy::test';
 $t_badLock         = 'dummy::bad';
 initDefaults();
 try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_goodLock,$t_badLock);
    $t_status       = $mpo_secure->checklock($t_goodLock);
    $t_statusB       = $mpo_secure->checklock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value good: ');
  printVariables($t_statusB, 'Value bad: ');
?>

<h3>Test 5.7: With Argument</h3>
<p class="clean">Good.</p>
<?php
  $t_goodLock       = 'dummy::test';
  initDefaults();
  try {
    $mpo_secure     = new \mpc\mpc_secure($mpo_errors);
    $t_status       = $mpo_secure->secure($t_goodLock);
    $t_status       = $mpo_secure->checklock($t_goodLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value good: ');
?>

<h2 id="listlock">6. listlock</h2>

<ol>
  <li>Check no arguments</li>
  <li>Check with bad argument - array</li>
  <li>Check with too many arguments</li>
  <li>Check with bad argument - no match</li>
  <li>Check with partial argument</li>
</ol>

<?php
    initDefaults();
  $mpo_secure       = new \mpc\mpc_secure($mpo_errors);
  $t_status         = $mpo_secure->secure('dummy::secure1');
  $t_status         = $mpo_secure->secure('dummy::secure2');
  $t_status         = $mpo_secure->secure('dummy::secure3');
  $t_status         = $mpo_secure->secure('dummy::secure4');
  $t_status         = $mpo_secure->lock('dummy::lock1');
  $t_status         = $mpo_secure->lock('dummy::lock2');
  $t_status         = $mpo_secure->lock('dummy::lock3');
  $t_status         = $mpo_secure->lock('dummy::lock4');
  $t_status         = $mpo_secure->lock('dummy::lock5');
  $t_status         = $mpo_secure->lock('dummy::lock6');
?>
<h3>Test 6.1: No Arguments</h3>
<p class="clean">Good.</p>
<?php
  try {
    $t_status       = $mpo_secure->listlock();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 6.2: Bad Argument - Array</h3>
<p class="alert">Fatal Error. Correct.</p>
<?php
  $t_badLock        = array('a','b');
  $t_status         = ' not run';

  try {
    $t_status       = $mpo_secure->listlock($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 6.3: Bad Argument - Too Many</h3>
<p class="alert">Works. Only first argument is run. Allow.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listlock('dummy::lock1', 'dummy::lock2');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value first: ');
?>

<h3>Test 6.4: Bad Argument - No Match</h3>
<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listlock('stupid::lock1');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 6.5: Parital Match</h3>
<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listlock('dummy');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h2 id="listlock">7. listsecure</h2>

<ol>
  <li>Check no arguments</li>
  <li>Check with bad argument - array</li>
  <li>Check with too many arguments</li>
  <li>Check with bad argument - no match</li>
  <li>Check with argument</li>
</ol>

<h3>Test 7.1: No Arguments</h3>
<p class="clean">Good.</p>
<?php
  try {
    $t_status       = $mpo_secure->listsecure();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 7.2: Bad Argument - Array</h3>
<p class="alert">Fatal Error. Correct.</p>
<?php
  $t_badLock        = array('a','b');
  $t_status         = ' not run';

  try {
    $t_status       = $mpo_secure->listsecure($t_badLock);
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 7.3: Bad Argument - Too Many</h3>
<p class="alert">Works. Only first argument is run. Allow.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listsecure('dummy::secure1', 'dummy::secure2');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value first: ');
?>

<h3>Test 7.4: Bad Argument - No Match</h3>
<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listsecure('stupid::secure1');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 7.5: Partial Match</h3>
<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listsecure('dummy');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h2 id="listlock">8. secure4prod</h2>

<ol>
  <li>Secure for Prod</li>
  <li>Check listlock</li>
  <li>Check listlock with string</li>
  <li>Check listsecure</li>
</ol>

<p>These should all return false.</p>

<h3>Test 8.1: Secure for Prod</h3>

<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->secure4prod();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 8.2: Test listlock</h3>

<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listlock();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 8.3: Test listlock with String</h3>

<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listlock('dummy');
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>

<h3>Test 8.3: Test listsecure</h3>

<p class="clean">Good.</p>
<?php
  $t_status         = ' not run';
  try {
    $t_status       = $mpo_secure->listsecure();
  } catch(Throwable $e) { printError($e); }
  printVariables($t_status, 'Value: ');
?>


</body>
</html>
