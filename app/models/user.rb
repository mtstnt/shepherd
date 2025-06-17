class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  ## Permission Management
  has_many :user_permissions, class_name: "Acl::UserPermission", dependent: :destroy
  has_many :permissions, through: :user_permissions, class_name: "Acl::Permission"

  has_many :user_roles, class_name: "Acl::UserRole", dependent: :destroy
  has_many :roles, through: :user_roles, class_name: "Acl::Role"

  ## Organization Management
  belongs_to :organization, optional: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Checks if a user has permission to perform an action on a resource
  # @param resource [String] The resource to check permission for
  # @param action [String] The action to check permission for
  # @return [Boolean] true if the user has permission, false otherwise
  #
  # Permission is granted if either:
  # 1. The user has a role that has the permission
  # 2. The user has the permission directly assigned
  def is_permissible_for?(resource, action)
    roles.joins(:permissions).where(permissions: { resource: resource, action: action }).exists? or
    permissions.where(resource: resource, action: action).exists?
  end
end
