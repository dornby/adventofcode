require_relative "data"

def set_current_dir_path(current_dir_path, new_dir)
  current_dir_path.push(new_dir)
end

def go_back_one_dir(current_dir_path)
  current_dir_path.pop
end

def fetch_list(start_index)
  list = []

  DATA[start_index..].each do |line|
    break if line[0] == "$"

    list.push(line)
  end

  list
end

def add_dirs_to_dir(dirs_to_add, current_dir_path, disk)
  current_dir = disk

  current_dir_path.each do |path_el|
    current_dir = current_dir.fetch(path_el)
  end

  dirs_to_add.each do |dir_to_add|
    current_dir[dir_to_add.delete_prefix("dir ")] = {}
  end
end

def add_files_to_dir(files_to_add, current_dir_path, disk)
  current_dir = disk

  current_dir_path.each do |path_el|
    current_dir = current_dir.fetch(path_el)
  end

  files_to_add.each do |file_to_add|
    file_name = file_to_add.split(" ")[1]
    file_size = file_to_add.split(" ")[0]
    current_dir[file_name] = file_size
  end
end

disk = { "/" => {} }
current_dir_path = []

DATA.each_with_index do |line, i|
  if line[0] == "$"
    if line[2..3] == "cd"
      if line[5..6] == ".."
        go_back_one_dir(current_dir_path)
      else
        new_dir = line[5..]
        set_current_dir_path(current_dir_path, new_dir)
      end
    elsif line[2..3] == "ls"
      list = fetch_list(i + 1)
      add_dirs_to_dir(list.select { |l| l[0..2] == "dir" }, current_dir_path, disk)
      add_files_to_dir(list.reject { |l| l[0..2] == "dir" }, current_dir_path, disk)
    end
  else
    next
  end
end

def add_sum_to_dirs(disk, dir_sizes, dirs_to_sum)
  disk.each do |key, value|
    if value.is_a?(Hash)
      path = (dirs_to_sum + [key]).join(".")
      if dir_sizes[path]
        add_sum_to_dirs(value, dir_sizes, (dirs_to_sum + [key]))
      else
        dir_sizes[path] = 0
        add_sum_to_dirs(value, dir_sizes, (dirs_to_sum + [key]))
      end
    else
      dirs_to_sum.each_with_index do |dir_to_sum, i|
        path = dirs_to_sum[0..i].join(".")
        dir_sizes[path] += value.to_i
      end
    end
  end
end

dir_sizes = {}

add_sum_to_dirs(disk, dir_sizes, [])

dirs_with_max_value = dir_sizes.select { |_k, v| v <= 100000 }

# p dirs_with_max_value.values.sum

available_space = 70000000 - dir_sizes["/"]
needed_space = 30000000 - available_space

p dir_sizes.select { |_k, v| v >= needed_space }.values.min
