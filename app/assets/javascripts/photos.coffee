# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class FolderAdapter extends MindpinBucketsAdapter
  constructor: (@$fm, @$el)->

  get_buckets_success: (buckets) ->
    str = ''
    that = this
    jQuery.each buckets, ->
      bucket = this
      str += that._str_bucket(bucket.id, bucket.name, bucket.added)
    console.log str
    @$el.find('.buckets').html(str)
    # li点击事件绑定：添加、移除到folder
    @$el.find('.buckets li.group').click ->
      console.log 'click li'
      if $(this).hasClass('unbucketed')
        bucket_id = $(this).data('id')
        bucket_type = that.$fm.bucket_type
        console.log "bucket_id: #{bucket_id}"
        console.log "bucket_type: #{bucket_type}"
        that.$fm.buckets.add_to_bucket(that.$fm.resource_type, that.$fm.resource_id, bucket_type, bucket_id)
      else
        bucket_id = $(this).data('id')
        bucket_type = that.$fm.bucket_type
        console.log "bucket_id: #{bucket_id}"
        console.log "bucket_type: #{bucket_type}"
        that.$fm.buckets.remove_from_bucket(that.$fm.resource_type, that.$fm.resource_id, bucket_type, bucket_id)

  create_bucket_success: (bucket) ->
    console.log 'create_bucket_success'
    console.log bucket
    that = this
    str = @_str_bucket(bucket.id, bucket.name, false)
    @$fm.modal_folders.find('.buckets').prepend str
    @$fm.modal_folders.find('li.group:first').click ->
      if $(this).hasClass('unbucketed')
        bucket_id = $(this).data('id')
        bucket_type = that.$fm.bucket_type
        console.log "bucket_id: #{bucket_id}"
        console.log "bucket_type: #{bucket_type}"
        that.$fm.buckets.add_to_bucket(that.$fm.resource_type, that.$fm.resource_id, bucket_type, bucket_id)
      else
        bucket_id = $(this).data('id')
        bucket_type = that.$fm.bucket_type
        console.log "bucket_id: #{bucket_id}"
        console.log "bucket_type: #{bucket_type}"
        that.$fm.buckets.remove_from_bucket(that.$fm.resource_type, that.$fm.resource_id, bucket_type, bucket_id)

    @$fm.modal_new_folder.find('.name').val('')
    @$fm.modal_new_folder.find('.desc').val('')
    @$fm.modal_new_folder.modal('hide')

  add_to_bucket_success: (bucket) ->
    console.log 'add_to_bucket_success'
    console.log bucket
    @$el.find("[data-id=#{bucket.id}]").removeClass('unbucketed').addClass('bucketed')

  remove_from_bucket_success: (bucket) ->
    console.log 'remove_from_bucket_success'
    console.log bucket
    @$el.find("[data-id=#{bucket.id}]").removeClass('bucketed').addClass('unbucketed')

  _str_bucket: (id, name, added) ->
    console.log added
    "<li class=\"group #{if !added then "un" else ""}bucketed\" data-id=\"#{id}\" id=\"bucket_#{id}\"><a href=\"javascript:;\"><strong>#{name}</strong><!--<span class=\"bucket-meta\">1 photos</span>--><span class=\"bucket-meta\">更新时间</span></a></li>"

class FolderManager
  # 大致流程:
  # 1. 一次性创建两个modal(buckets, new_bucket)
  # 2. 一次性读取buckets, 写入buckets-modal
  # 3. 绑定各种点击事件(按钮click, new click, bucket click)
  # 4. 处理各种回调
  constructor: (@$el) ->
    @_init()

  _init: () ->
    @resource_type = @$el.data('resource-type')
    @resource_id = @$el.data('resource-id')
    console.log @$el
    console.log @resource_type
    console.log @resource_id
    @bucket_type = "folder"
    @modal_folders = jQuery('#modal-folders')
    @modal_new_folder = jQuery('#modal-new-folder')
    @adapter = new FolderAdapter(@, @modal_folders)
    @buckets = new MindpinBuckets("", @adapter)
    @_init_buckets()
    @bind()

  _init_buckets: () ->
    console.log 'bind'
    @buckets.buckets(@bucket_type, @resource_type, @resource_id)

  bind: () ->
    console.log 'bind'
    # 添加按钮点击
    @$el.click () => 
      console.log 'el click'
      @modal_folders.modal('show')

    # 创建按钮点击
    @modal_folders.find('.new').click () => 
      console.log 'click new'
      console.log @
      @modal_new_folder.modal('show')
      # 新建一个new modal，处理创建事件
      #@buckets.create_buckets(@bucket_type)
      #console.log @modal_folders
      #@modal_folders.modal('show')
    @modal_new_folder.find('.create').click () =>
      console.log 'create'
      name = @modal_new_folder.find('.name').val()
      desc = @modal_new_folder.find('.desc').val()
      console.log name
      console.log desc
      @buckets.create_bucket(@bucket_type, name, desc)

jQuery(document).on 'ready page:load', ->
  if jQuery('.page-demo a.add_to_folder').length > 0
    window.folder_manager = new FolderManager(jQuery('.page-demo a.add_to_folder'))
