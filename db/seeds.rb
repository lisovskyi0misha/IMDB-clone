text = "A screenplay synopsis is a vital tool in the filmmaking world, helping you sell\s
your movie idea to agents, managers, producers, studio execs - basically anyone in a film production job.\s
Before anyone commits to reading your full screenplay, they\'ll want to check out a one-page synopsis. So it\'s super\s
important that you get it right.\n\n
The likes of screenwriting maestro Aaron Sorkin probably won\'t have any trouble getting someone to read their script\s
without a synopsis. But if you\'re not in Sorkin\'s league, you\'ll probably spend a bunch of time emailing query\s
letters to try to grab people\'s attention. To do that, you\'ll need to include a short synopsis that sells."

{
  'Avatar' => [:action, 'avatar'], 'Batman Begins' => [:action, 'batman-begins'],
  'Django Unchained' => [:western, 'django_unchained'], 'Dune' => [:fantasy, 'dune'],
  'Gladiator' => [:action, 'gladiator'], 'Inception' => [:comedy, 'inception'],
  'Inglourious Basterds' => [:comedy, 'inglourious_basterds'], 'Interstellar' => [:fantasy, 'interstellap'],
  'Lord of The Rings: The Fellowship of the Ring' => [:fantasy, 'lotr_1'],
  'Lord of The Rings: The Two Towers' => [:fantasy, 'lotr_2'],
  'Lord of The Rings: The Return of the King' => [:fantasy, 'lotr_3'],
  'The Dark Knight' => [:action, 'the_dark_knight'], 'The Dark Knigth Rises' => [:action, 'the_dark_knight_rises'],
  'The Last Samurai' => [:action, 'the_last_samurai'], 'Troy' => [:action, 'troy']
}.each do |title, params|
  m = Movie.create(title:, category: params.first, text:)
  m.image.attach(io: File.open("#{Rails.root}/app/assets/images/#{params.last}.png"), filename: params.last)
end

User.create(name: 'Admin', email: 'admin@test', password: '123123',
  password_confirmation: '123123', confirmed_at: Date.today, admin: true)

User.create(name: 'User', email: 'user@test', password: '123123',
  password_confirmation: '123123', confirmed_at: Date.today, admin: true)

Movie.find_by(title: 'Lord of The Rings: The Fellowship of the Ring').trailer
  .attach(io: File.open("#{Rails.root}/app/assets/images/trailer.mp4"), filename: 'trailer.mp4')
