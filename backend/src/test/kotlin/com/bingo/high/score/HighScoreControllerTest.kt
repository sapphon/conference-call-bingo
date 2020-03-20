package com.bingo.high.score

import assertk.assertThat
import assertk.assertions.containsExactly
import assertk.assertions.isEqualTo
import org.junit.jupiter.api.Test
import org.mockito.Mockito.`when`
import org.mockito.Mockito.verify
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.core.ParameterizedTypeReference
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.web.util.UriComponentsBuilder

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
internal class HighScoreControllerTest {

    @Autowired
    lateinit var testRestTemplate: TestRestTemplate

    @MockBean
    lateinit var highScoreRepository: HighScoreRepository

    val highScoresUrl = UriComponentsBuilder.fromPath("/highscores").build().toUri()
    class ListHighScores : ParameterizedTypeReference<List<HighScore>>()

    @Test
    internal fun `should retrieve all the high scores from the database`() {

        `when`(highScoreRepository.findAll()).thenReturn(listOf(HighScoreEntity("id", "score", "player")))

        val highScores = testRestTemplate.exchange(highScoresUrl, HttpMethod.GET, null, ListHighScores()).body

        assertThat(highScores!!).containsExactly(HighScore("score", "player"))
    }

    @Test
    internal fun `should save a high score to the database`() {
        val highScoreEntity = HighScoreEntity(score = "score", player = "player")

        val response = testRestTemplate.postForEntity(highScoresUrl, HighScore("score", "player"), Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        verify(highScoreRepository).save(highScoreEntity)
    }
}


