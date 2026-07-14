User.find_or_create_by!(email: "jack@kinvrdigital.com") do |u|
  u.name     = "Jack"
  u.surname  = "Lester"
  u.password = "BirdieBoard2026!"
  u.role     = "organiser"
end
