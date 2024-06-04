# frozen_string_literal: true

module API::V1
  class Task::ItemsController < BaseController
    include Task::Items::Concerns::Rendering

    def index
      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Listing.call(task_list:, filter: params[:filter])
      in Solid::Failure(:task_list_not_found, _)
        render_task_or_list_not_found
      in Solid::Success(tasks:)
        data = tasks.pluck(*task_attribute_names).collect! { map_json_attributes(_1) }

        render_json_with_success(status: :ok, data:)
      end
    end

    def create
      create_params = params.require(:task).permit(:name)

      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Creation.call(task_list:, **create_params)
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      in Solid::Success(task:)
        render_json_with_attributes(task, :created)
      end
    end

    def update
      update_params = params.require(:task).permit(:name, :completed)

      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Updating.call(task_list:, id: params[:id], **update_params)
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Failure(input:)
        render_json_with_model_errors(input)
      in Solid::Success(task:)
        render_json_with_attributes(task, :ok)
      end
    end

    def destroy
      task_list = Account::Task::List::Entity.new(id: current_member.task_list_id)

      case Account::Task::Item::Deletion.call(task_list:, id: params[:id])
      in Solid::Failure(:task_list_not_found | :task_not_found, _)
        render_task_or_list_not_found
      in Solid::Success
        render_json_with_success(status: :ok)
      end
    end
  end
end
