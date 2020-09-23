defmodule HippoAbs.ServiceTest do
  use HippoAbs.DataCase

  alias HippoAbs.Service

  describe "devices" do
    alias HippoAbs.Service.Device

    @valid_attrs %{device_id: 42, name: "some name"}
    @update_attrs %{device_id: 43, name: "some updated name"}
    @invalid_attrs %{device_id: nil, name: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Service.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Service.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Service.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Service.create_device(@valid_attrs)
      assert device.device_id == 42
      assert device.name == "some name"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Service.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = Service.update_device(device, @update_attrs)
      assert device.device_id == 43
      assert device.name == "some updated name"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Service.update_device(device, @invalid_attrs)
      assert device == Service.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Service.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Service.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Service.change_device(device)
    end
  end

  describe "farms" do
    alias HippoAbs.Service.Farm

    @valid_attrs %{ip: "some ip", name: "some name"}
    @update_attrs %{ip: "some updated ip", name: "some updated name"}
    @invalid_attrs %{ip: nil, name: nil}

    def farm_fixture(attrs \\ %{}) do
      {:ok, farm} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Service.create_farm()

      farm
    end

    test "list_farms/0 returns all farms" do
      farm = farm_fixture()
      assert Service.list_farms() == [farm]
    end

    test "get_farm!/1 returns the farm with given id" do
      farm = farm_fixture()
      assert Service.get_farm!(farm.id) == farm
    end

    test "create_farm/1 with valid data creates a farm" do
      assert {:ok, %Farm{} = farm} = Service.create_farm(@valid_attrs)
      assert farm.ip == "some ip"
      assert farm.name == "some name"
    end

    test "create_farm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Service.create_farm(@invalid_attrs)
    end

    test "update_farm/2 with valid data updates the farm" do
      farm = farm_fixture()
      assert {:ok, %Farm{} = farm} = Service.update_farm(farm, @update_attrs)
      assert farm.ip == "some updated ip"
      assert farm.name == "some updated name"
    end

    test "update_farm/2 with invalid data returns error changeset" do
      farm = farm_fixture()
      assert {:error, %Ecto.Changeset{}} = Service.update_farm(farm, @invalid_attrs)
      assert farm == Service.get_farm!(farm.id)
    end

    test "delete_farm/1 deletes the farm" do
      farm = farm_fixture()
      assert {:ok, %Farm{}} = Service.delete_farm(farm)
      assert_raise Ecto.NoResultsError, fn -> Service.get_farm!(farm.id) end
    end

    test "change_farm/1 returns a farm changeset" do
      farm = farm_fixture()
      assert %Ecto.Changeset{} = Service.change_farm(farm)
    end
  end
end
