# Сервис для проведения спортивной версии "вопрос-ответ"

## Требования

* Ruby 3
* Yarn
* Postgres

## Запуск

```
bundle i
yarn i
rails db:create:all
rails db:migrate
```

Делаем админа

```
rails c
User.create email: "ex@ex.com", password: "your_pass", password_confirmation: "your_pass", name: "name", role: :admin
```

Запускаем

```
bin\dev (это если nix)
s.cmd (если win)
```

В приложении используется recaptcha и, в идеале, для неё надо добавить свои ключи, но можно этого не делать, а просто изменить методы [тут](https://github.com/bodrovis/MCSAnswer/blob/master/app/controllers/sessions_controller.rb#L37) и [тут](https://github.com/bodrovis/MCSAnswer/blob/master/app/controllers/users_controller.rb#L70), написав

```ruby
def verify_captchas
  true
end
```

(c) 2022 [Ilya Krukowski](http://bodrovis.tech), [GuideDAO](https://www.guidedao.xyz/)
