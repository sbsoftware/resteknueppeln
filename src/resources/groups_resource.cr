require "base58"

class GroupsResource < ApplicationResource
  def create
    unless body = ctx.request.body
      ctx.response.status = :bad_request
      return
    end

    name = nil
    HTTP::Params.parse(body.gets_to_end) do |key, value|
      case key
      when "name"
        name = value
      end
    end

    if name
      group = Group.create(name: name, access_token: Base58.encode(Random::Secure.random_bytes(9)))

      GroupUser.create(group_id: group.id, session_id: ctx.session.id.to_s)

      redirect GroupsResource.uri_path(group.id)
    end
  end

  def show
    group = Group.find(id)

    unless group.group_users.any? { |gu| gu.session_id == ctx.session.id.to_s }
      redirect HomeResource.uri_path
      return
    end

    render GroupView.new(ctx: ctx, group: group)
  end
end
