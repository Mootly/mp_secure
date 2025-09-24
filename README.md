# MoosePlum Secure Objects Class

Repo: [Mootly/mp_secure](https://github.com/Mootly/mp_secure)

This is a standalone version of the object locking class used by MoosePlum, for those who want a really simple and consistent method for protecting data in objects.

Use requires adding calls to the secure objects class in your class definitions and letting it handle all locking/unlocking of properties. Such properties should be private and only accessible through the class methods for that class.

> [!WARNING]
> This is NOT a secure solution.

Rather it is meant to reducing coding errors in large projects by marking properties as locked once set.

All it does is give you the ability to label things as locked from from further editing. Any code using it will still need to check and respect that lock.

- Locked properties and methods can be unlocked again.
- Secured properties and methods cannot.

It uses an array of registered strings for tracking, so it can be used to lock down anything that can call the class instance to pass it a string or test for values. It was written to be included in other classes to standardize locking, but can be used for anything.

Except instantiation, which expects an error handling object, and `secure4prod`, which takes no arguments, all methods expect one and only one string.

> [!WARNING]
> This is NOT a robust solution.

Caveat emptor.

Except it's free, so maybe more sort of caveat donum?

## System Requirements

Requirements are pretty simple.

- This was developed using PHP 8.1 & 8.2. It should work in PHP 7.0 and up, but has **not** been test for backward compatibility.
- A web server, or what's the point really?

## Dependencies

- [mpc_errors](https://github.com/Mootly/mp_errors)

## Defaults

The namespace for this class is `mpc`.

The location of this class definition should be your vendor library. For inclusion with other MoosePlum stuff that would be `/_lib/mootly/mp_secure/`.

## Assets

The files in this set are as follows:

| path               | description                                            |
| ------------------ | ------------------------------------------------------ |
| composer.json      | Yep, we are using [Composer](https://getcomposer.org). |
| CHAMGELOG.md       | The changelog for this utility.                        |
| LICENSE.md         | License notice ( [MIT](https://mit-license.org) ).     |
| README.md          | This document.                                         |
| mpt_secure.php     | Local unit test file to make sure things work.         |
| src/mpc_secure.php | The class definition.                                  |
| src/mpi_secure.php | The interface for the class.                           |

## Installation

### Manual Installation

Put this class definition and any dependencies into your vendor library. For inclusion with other MoosePlum stuff that would be `/_lib/mootly/mp_secure/`.

Use your preferred method for including classes in your code.

### Composer Installation

This class definition is listed on [Packagist](https://packagist.org/users/Mootly/packages/) for installation using Composer.

See the [Composer](https://getcomposer.org) website for a directions on how to properly install Composer on your system.

Once Composer is installed and running, add the following code to the `composer.json` file at the root of your website.

Make sure you have the following listed as required. Adjust version numbers as necessary. See the `composer.json` in this class definition for required versions of dependencies for this version of the package.

```json
"require": {
  "php": ">=8.0.0",
  "mootly/mp_errors": "*",
  "mootly/mp_secure": "*"
}
```

If necessary for your configuration, make sure you have the following autoload definitions listed in your `composer.json`. Adjust the first step in the path as needed for the location of your vendor library.

```json
"autoload": {
  "classmap": [
    "_lib/mootly/mp_errors",
    "_lib/mootly/mp_secure"
  ]
}
```

In your terminal of choice, navigate to the root of your website and run the following command. (Depending on how you installed composer, this may be different.)

```pwsh
composer update
```

This should install this class definition and related dependencies in your vendor library and sets up composer to link them into your application.

To be safe you can also run the following to rebuild the composer autoloader and make sure your classes are correctly registered.

```pwsh
composer dump-autoload -o
```

Make sure you have the following line in your page or application initialization code before using this class definition. Adjust accordingly based on the location of your vendor library.

```php
require_once "<site root>/<vendor lib>/autoload.php;"
```

That should be all your need to do to get it up and running.

## Configuration

This class definition has one dependency that needs to be called before it: `mootly\mpc_errors`.

If you are using autoloading, and you follow MoosePlum naming conventions, the recommended method for instantiation is as follows:

```php
if (!isset($mpo_errors)) { $mpo_errors  = new \mpc\mpc_errors(); }
if (!isset($mpo_secure)) { $mpo_secure  = new \mpc\mpc_secure($mpo_errors); }
```

It is recommended that you create a single class instance and load it into your other objects as a depedency, as has been done above with the `mpc_errors` instance.

## Usage

The use of namespaces or other unique identifiers to create unique strings for locking is strongly encouraged.

Examples:

- mpo_parts::main_body
- mpo_menus::main_nav::home_link

Autogeneration examples:

- `__CLASS__.'::'.someProp`
- `__CLASS__.'::'.__METHOD__`
- `__CLASS__.'_'.self::$iCount++` (for multiple instances)

For security add a hash of some sort that is always used for all calls by a given class. This prevents others without access to private properties from overwriting any locks. Examples of PHP hash generators:

- `md5(__CLASS__)`
- `md5(rand())`
- `uniqid()`
- `bin2hex(random_bytes(16))`

Since these will only persist for as long as it takes for PHP to generate and send out an HTTP response, they do not need to be overly secure. There are only milliseconds to guess the hash before it is gone.

MoosePlum classes define the following property on instantiation to ensure unique names.

```php
$this->classRef = bin2hex(random_bytes(8)).'::'.__CLASS__;
```

### Methods

#### `checklock`

Pass a unique identifier for a given property or method to check whether it is locked.

- Return the string 'locked' for locked properties or methods.
- Return the string 'secured' for secured properties or mtheods.
- Otherwise return false.

```php
public checklock(string) : string|bool
```

#### `listlock`

Generates a list of all locked elements.

Returns false if there are no locked elements.

If you lock this method, it will only provide matches that begin with the string provided.

If you secure this method, it will always return false.

```php
public listlock(string) : array|bool
```

#### `listsecure`

Generates a list of all secured elements.

Returns false if there are no secured elements.

If you lock this method, it will only provide matches that begin with the string provided.

If you secure this method, it will always return false.

```php
public securelock(string) : array|bool
```

#### `lock`

Lock an element from further updates.

It takes a string that is a unique identifier for the element to be locked.

```php
public lock(string) : bool
```

#### `unlock`

Unlock a locked element.

It takes a string that is a unique identifier for the element to be unlocked.

Secured elements cannot be unlocked.

```php
public lock(string) : bool
```

#### `secure`

Secure an element from further updates.

It takes a string that is a unique identifier for the element to be secured.

Secured elements cannot be unlocked.

```php
public secure(string) : bool
```

#### `secure4prod`

Secures this class so that `listlock()` and `listsecure()` cannot be used.

It takes no arguments.

Neither method locked by this should be used in a production environment. They can both allow classes access to each other's lock settings.

```php
public secure4prod() : bool
```
