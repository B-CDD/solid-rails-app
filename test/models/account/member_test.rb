require "test_helper"

class Account::MemberTest < ActiveSupport::TestCase
  test "validations" do
    uuid = account_members(:one).uuid

    member = Account::Member.new

    assert_not_predicate member, :valid?

    member.uuid = uuid

    assert_predicate member, :valid?

    member.uuid = "foo"

    assert_not_predicate member, :valid?

    member.uuid = uuid
    member.task_list_id = [0, -1].sample

    assert_not_predicate member, :valid?

    member.task_list_id = 1

    assert_predicate member, :valid?

    member.account_id = [0, -1].sample

    assert_not_predicate member, :valid?

    member.account_id = 1

    assert_predicate member, :valid?
  end

  test ".fetch_by with uuid" do
    record = account_members(:one)

    create_task_list(record.account, name: "Foo")

    member = Account::Member.fetch_by(uuid: record.uuid)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal record.account.id, member.account_id
    assert_equal record.inbox.id, member.task_list_id

    assert_equal record.inbox, member.task_list
    assert_equal record.account, member.account

    assert_equal record.task_lists, member.task_lists
    assert_equal 2, member.task_lists.size

    assert_predicate member, :uuid?
    assert_predicate member, :account_id?
    assert_predicate member, :task_list_id?
    assert_predicate member, :account?
    assert_predicate member, :task_list?

    # ---

    uuid = ::UUID.generate

    member = Account::Member.fetch_by(uuid:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with uuid and account_id" do
    record = account_members(:one)
    account = accounts(:one)

    member = Account::Member.fetch_by(uuid: record.uuid, account_id: account.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal account.inbox.id, member.task_list_id

    # ---

    member = Account::Member.fetch_by(uuid: record.uuid, account_id: accounts(:two).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    uuid = ::UUID.generate

    member = Account::Member.fetch_by(uuid:, account_id: account.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with uuid and task_list_id" do
    record = account_members(:one)
    task_list = create_task_list(record.account, name: "Foo")

    member = Account::Member.fetch_by(uuid: record.uuid, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal task_list.id, member.task_list_id
    assert_equal task_list.account_id, member.account_id

    # ---

    member = Account::Member.fetch_by(uuid: record.uuid, task_list_id: task_lists(:two_inbox).id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    uuid = ::UUID.generate

    member = Account::Member.fetch_by(uuid:, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end

  test ".fetch_by with uuid, account_id, and task_list_id" do
    record = account_members(:one)
    account = accounts(:one)
    task_list = create_task_list(account, name: "Foo")

    member = Account::Member.fetch_by(uuid: record.uuid, account_id: account.id, task_list_id: task_list.id)

    assert_predicate member, :authorized?
    assert_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_equal account.id, member.account_id
    assert_equal task_list.id, member.task_list_id

    # ---

    member = Account::Member.fetch_by(uuid: record.uuid, account_id: accounts(:two).id, task_list_id: task_list.id)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id

    # ---

    task_list_id = task_lists(:two_inbox).id

    member = Account::Member.fetch_by(uuid: record.uuid, account_id: account.id, task_list_id:)

    refute_predicate member, :authorized?
    refute_predicate member, :persisted?

    assert_equal record.uuid, member.uuid
    assert_nil member.account_id
    assert_nil member.task_list_id
  end
end
