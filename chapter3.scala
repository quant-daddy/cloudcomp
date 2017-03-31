
/** Preparing the data */
import org.apache.spark.mllib.recommendation._
import org.apache.spark.rdd._

val rawUserArtistData = sc.textFile("hdfs:///user/suraj/music/user_artist_data.txt")

/** check the range of userID */
rawUserArtistData.map(row => row.split(" ")(0).toDouble).stats()

val rawArtistData = sc.textFile("hdfs:///user/suraj/music/artist_data.txt")

val artistByID = rawArtistData.flatMap( line => {
  val (id, name) = line.span(_ != '\t')
  if (name.isEmpty) {
    None
  } else {
    try {
      Some((id.toInt, name.trim))
    } catch {
      case e: NumberFormatException => None
    }
  }
})


val rawArtistAlias = sc.textFile("hdfs:///user/suraj/music/artist_alias.txt")
val artistAlias = rawArtistAlias.flatMap( line => {
  val tokens = line.split("\t")
  if (tokens(0).isEmpty) {
    None
  } else {
    Some((tokens(0).toInt, tokens(1).toInt))
  }
}).collectAsMap()

val bArtistAlias = sc.broadcast(artistAlias)

val trainData = rawUserArtistData.map { line =>
  val Array(userID, artistID, count) = line.split(' ').map(_.toInt)
  val finalArtistID = bArtistAlias.value.getOrElse(artistID, artistID)
  Rating(userID, finalArtistID, count)
}.cache()

val model = ALS.trainImplicit(trainData, 10, 5, 0.01, 1.0)

:load areaUnderCurve.scala

def buildCounts(
  rawUserArtistData: Dataset[String],
  bArtistAlias: Broadcast[Map[Int,Int]]): DataFrame = {
  rawUserArtistData.map { line =>
    val Array(userID, artistID, count) = line.split(' ').map(_.toInt)
    val finalArtistID = bArtistAlias.value.getOrElse(artistID, artistID)
    (userID, finalArtistID, count)
  }.toDF("user", "artist", "count")
}

val allData = buildCounts(rawUserArtistData, bArtistAlias)
val Array(trainData, cvData) = allData.randomSplit(Array(0.9, 0.1))
trainData.cache()
cvData.cache()
