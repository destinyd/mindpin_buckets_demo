# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class FolderHook extends MindpinHook
  constructor: (@$fm) ->
    @modal_folders = jQuery('#modal-folders')
    @_init()

  _init: () ->
    # 创建按钮点击
    @modal_folders.find('.new').click () => 
      console.log 'click new'
      @modal_new_folder.modal('show')


    @modal_new_folder = jQuery('#modal-new-folder')

    @modal_new_folder.find('.create').click () =>
      console.log 'create'
      name = @modal_new_folder.find('.name').val()
      desc = @modal_new_folder.find('.desc').val()
      console.log name
      console.log desc
      @$fm.create_bucket(name, desc)
    
  el_click: (el) ->
    console.log 'hook el click'
    # todo
    @modal_folders.modal('show')

  buckets_success: (buckets) =>
    console.log 'hook buckets success'
    console.log buckets
    str = ''
    that = this
    jQuery.each buckets, ->
      bucket = this
      str += that._str_bucket(bucket.id, bucket.name, bucket.added)
    @modal_folders.find('.buckets').html(str)
    # li点击事件绑定：添加、移除到folder
    @modal_folders.on 'click', '.buckets li.group', ->
      console.log 'click li'
      if $(this).hasClass('unbucketed')
        bucket_id = $(this).data('id')
        that.$fm.add_to_bucket(bucket_id) # that.$fm.resource_type, that.$fm.resource_id, bucket_type, bucket_id)
      else
        bucket_id = $(this).data('id')
        bucket_type = that.$fm.bucket_type
        that.$fm.remove_from_bucket(bucket_id)

  create_bucket_success: (bucket) =>
    console.log 'hook create bucket success'
    that = this
    str = @_str_bucket(bucket.id, bucket.name, false)
    @modal_folders.find('.buckets').append str

    @modal_new_folder.find('.name').val('')
    @modal_new_folder.find('.desc').val('')
    @modal_new_folder.modal('hide')

  add_to_bucket_success: (bucket) =>
    @modal_folders.find("[data-id=#{bucket.id}]").removeClass('unbucketed').addClass('bucketed')

  remove_from_bucket_success: (bucket) ->
    console.log 'remove_from_bucket_success'
    console.log bucket
    @modal_folders.find("[data-id=#{bucket.id}]").removeClass('bucketed').addClass('unbucketed')

  _str_bucket: (id, name, added) ->
    "<li class=\"group #{if !added then "un" else ""}bucketed\" data-id=\"#{id}\" id=\"bucket_#{id}\"><a href=\"javascript:;\"><strong>#{name}</strong><!--<span class=\"bucket-meta\">1 photos</span>--><span class=\"bucket-meta\">更新时间</span></a></li>"


jQuery(document).on 'ready page:load', ->
  configs = 
    bucket_type: "Folder"
    hook_class: FolderHook

  window.mindpin_buckets = new MindpinBuckets(configs)
