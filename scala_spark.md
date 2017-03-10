### Hadoop Filesystem command
* hadoop fs -"usual shell command" to access the filesystem
 - hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2

#### Hadoop filesystem important commands
* hadoop fs -put `<localsrc> ... <dst>`

#### Differencce between val, var, and def in scala
* def - defines an immutable label for the right side content which is lazily evaluated - evaluate by name.
* val - defines an immutable label for the right side content which is eagerly/immediately evaluated - evaluated by value.
* var - defines a mutable variable, initially set to the evaluated right side content.

#### Companion object in scala
Most singleton objects do not stand alone, but instead are associated with a class of the same name.
When this happens, the singleton object is called the companion object of the class, and the class is called the companion class of the object.
static is not a keyword in Scala. Instead, all members that would be static, including classes, should go in a singleton object instead. 
Detail: <http://docs.scala-lang.org/tutorials/tour/singleton-objects.html>
