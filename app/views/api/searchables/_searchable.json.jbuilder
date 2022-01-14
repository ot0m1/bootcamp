json.title matched_document(searchable).title
json.url searchable_url(searchable)
json.model_name matched_document(searchable).class.to_s.tableize.singularize
json.model_name_original searchable.class.to_s.tableize.singularize
json.model_name_with_i18n t("activerecord.models.#{matched_document(searchable).class.to_s.tableize.singularize}")
json.summary searchable_summary(filtered_message(searchable), 90, params[:word])
json.updated_at searchable.updated_at
if searchable.respond_to?(:user)
  json.login_name searchable.user.login_name
  json.user_id searchable.user.id
  json.contributor_login_name matched_document(searchable).user.login_name
  json.contributor_user_id matched_document(searchable).user.id
end
