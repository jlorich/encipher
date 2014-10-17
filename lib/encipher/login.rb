# module Encipher
#   # Enviornment variable storage
#   class Login < Value

#     # Store a new environment variable
#     def set(username, password, description)
#       require_user

#       LoginItem.all(name: name).destroy

#       User.each do |user|
#         encrypted_username = security.encrypt(username.to_s, user.public_key.to_s)
#         encrypted_password = security.encrypt(password.to_s, user.public_key.to_s)
#         e = LoginItem.create(
#           user: user,
#           username: encrypted_username,
#           password: encrypted_password,
#           description: description
#         )
#       end
#     end

#     def get(name)
#       require_user

#       security.decrypt current_user.login_items.all(name: name).first.value
#     end

#     def list
#       require_user

#       current_user.login_items.collect { |c| c.name }
#     end
#   end
# end