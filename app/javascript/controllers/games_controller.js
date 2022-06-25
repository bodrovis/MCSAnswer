import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
import { Modal } from 'bootstrap'

export default class GamesController extends Controller {
  static targets = [ "question", "answer", "start", "suggestAnswer", "answerer", "correct", "incorrect", "finish", "alarm" ]
  static values = { game: Number, host: Boolean, player: Boolean, playerId: Number }
  dialog = null
  currentQuestion = null

  initialize() {
    if (this.subscription) {
      return
    }

    this.subscription = this.createSubscription(this)
    this.dialog = new Modal('#current-question', {keyboard: false, backdrop: 'static'})
  }

  start(e) {
    e.preventDefault()

    if(!this.hostValue) return

    if (this.currentQuestion) {
      try {
        this.subscription.perform('start', {question: this.currentQuestion, game: this.gameValue})
      } catch (e) {
        console.error(e)
      }      
    }
  }

  showQuestion(e) {
    e.preventDefault()
    
    if(!this.hostValue) return

    this.subscription.perform('show_question', {game: this.gameValue, question: e.params.id})
  }

  async alarm(e) {
    e.preventDefault()
    
    if(!this.hostValue) return

    try {
      await this.doPost(`/api/games/${this.gameValue}/alarm`)
    } catch (e) {
      console.error(e)
    }
  }

  async correct() {
    if(!this.hostValue) return

    try {
      await this.doPost(`/api/games/${this.gameValue}/correct_answer`)
    } catch (e) {
      console.error(e)
    }
  }

  async incorrect() {
    if(!this.hostValue) return

    try {
      await this.doPost(`/api/games/${this.gameValue}/incorrect_answer`)
    } catch (e) {
      console.error(e)
    }
  }

  async finish() {
    if(!this.hostValue) return

    try {
      await this.doPost(`/api/games/${this.gameValue}/finish_question`)
    } catch (e) {
      console.error(e)
    }
  }

  async showAnswer() {
    if(!this.hostValue) return

    this.subscription.perform('show_answer', {question: this.currentQuestion, game: this.gameValue})
  }

  async suggestAnswer() {
    if(!this.playerValue) return

    try {
      await this.doPost(`/api/games/${this.gameValue}/suggest_answer`)
    } catch (e) {
      console.error(e)
    }
  }

  createSubscription(source) {
    return createConsumer().subscriptions.create({channel: 'GameChannel', game: this.gameValue}, {
      received(data) {
        switch (data['state']) {
          case 'next_question':
            source.doNextQuestion(data)
            break

          case 'answer_click':
            source.doAnswerClick(data)
            break

          case 'question_show':
            source.doQuestionShow(data)
            break

          case 'answer_ready':
            source.doAnswerReady(data)
            break

          case 'correct_answer':
            source.doCorrectAnswer(data)
            break

          case 'incorrect_answer':
            source.doIncorrectAnswer(data)
            break

          case 'finish_question':
            source.doFinishQuestion(data)
            break

          default: console.error(`Unknown state ${data['state']}`)
        }
      },
    })
  }

  doNextQuestion(data) {
    this.currentQuestion = data['id']

    document.getElementById("question-" + data['id']).innerHTML = ''
    this.questionTarget.innerText = data['body']

    if (this.hostValue) {
      this.show(this.startTarget)
      this.show(this.alarmTarget)
    }
    
    this.dialog.show()
  }

  doAnswerClick(_data) {
    if (this.hostValue) {
      this.hide(this.startTarget)
      this.show(this.finishTarget)
    }

    if (this.playerValue) {
      this.show(this.suggestAnswerTarget)
    }
  }

  doQuestionShow(data) {
    this.show(this.answerTarget)
    this.answerTarget.innerText = data['answer']
  }

  doAnswerReady(data) {
    this.answererTarget.innerText = data['player']

    if (this.playerValue) {
      this.hide(this.suggestAnswerTarget)
    }

    if (this.hostValue) {
      this.show(this.correctTarget)
      this.show(this.incorrectTarget)
    }
  }
  
  doCorrectAnswer(data) {
    this.answerGiven(data)
  }

  doIncorrectAnswer(data) {
    if (this.playerValue && data['valid_players'].includes(this.playerIdValue)) {
      this.show(this.suggestAnswerTarget)
    }
    this.answerGiven(data)
  }

  answerGiven(data) {
    if (this.hostValue) {
      this.hide(this.correctTarget)
      this.hide(this.incorrectTarget)
    }
    this.answererTarget.innerText = ''
    document.getElementById(`score-player-${data['answered_player']}`).innerText = data['score']
  }

  doFinishQuestion(_data) {
    if (this.hostValue) {
      this.hide(this.correctTarget)
      this.hide(this.incorrectTarget)
      this.hide(this.finishTarget)
    }

    if (this.playerValue) {
      this.hide(this.suggestAnswerTarget)
    }
    this.answererTarget.innerText = ''

    this.hide(this.answerTarget)
    this.dialog.hide()
  }

  show(el) {
    el.classList.remove('d-none')
  }

  hide(el) {
    el.classList.add('d-none')
  }

  async doPost(url) {
    const csrfToken = document.getElementsByName("csrf-token")[0].content;
    await fetch(url, {
      method: 'POST',
      headers: {
        "X-CSRF-Token": csrfToken
      }
    })
  }
}
