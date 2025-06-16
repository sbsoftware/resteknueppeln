require "./application_resource"

class AccessResource < ApplicationResource
  record AccessView, group : Group do
    css_class Container
    css_class Button

    ToHtml.instance_template do
      div Container do
        Crumble::Material::TopAppBar.new(
          leading_icon: nil,
          headline: "RESTEKNÜPPELN",
          trailing_icons: [] of Nil,
          type: :center_aligned
        )
        p do
          "Du wurdest eingeladen, an der Gruppe "
          strong { group.name }
          " teilzunehmen!"
        end

        form action: AccessResource.uri_path(group.access_token.value), method: "POST" do
          button Button do
            span do
              "Teilnehmen"
            end
          end
        end
      end
    end

    style do
      rule Container do
        maxWidth 600.px
        margin "0px auto"
        display Flex
        flexDirection Column
        alignItems Center
      end

      rule Button do
        border 1.px, Solid, Black
      end
    end
  end

  def show
    unless id?
      redirect HomeResource.uri_path
      return
    end

    unless group = Group.where({"access_token" => id}).first?
      redirect HomeResource.uri_path
      return
    end

    if GroupUser.where({"group_id" => group.id, "session_id" => ctx.session.id.to_s}).first?
      redirect GroupsResource.uri_path(group.id)
      return
    end

    render AccessView.new(group)
  end

  def update
    unless id?
      redirect HomeResource.uri_path
      return
    end

    unless group = Group.where({"access_token" => id}).first?
      redirect HomeResource.uri_path
      return
    end

    GroupUser.create(group_id: group.id, session_id: ctx.session.id.to_s)

    redirect GroupsResource.uri_path(group.id)
  end

  def self.uri_path_matcher
    /^#{root_path}(\/|\/([a-zA-Z0-9]+))$/
  end

  def id?
    self.class.match(@ctx.request.path).try { |m| m[2]? }
  end
end
