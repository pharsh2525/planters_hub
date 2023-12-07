ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    panel "Data Management" do
      ul do
        li link_to "Mangae Users", admin_users_path
        li link_to "Manage Plants", admin_plants_path
        li link_to "Manage Categories", admin_categories_path
        li link_to "Manage Provinces", admin_provinces_path
        # Add more links for other models
      end
    end

    # You can add more panels for other types of information or summaries if needed
  end
end
