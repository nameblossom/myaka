function showLink(id) {
    $('#link_form_method').val(id ? 'PUT' : 'POST');
    $('#link_form').attr('action', '/profile_links' + (id?'/'+id:''));
    $('#profile-link-editor').modal('show')
	.find('.modal-body')
	.text('Loading...')
	.load('/profile_links/' + (id ? id : 'new') + '?inline=yeah');
}

function deleteAka() {
    if (confirm('Are you sure you want to delete this link?')) {
	$('#link_form_method').val('DELETE').submit();
    }
}

function saveProfileLink() {
    $('#profile-link-editor input').attr('disabled','disabled');
    $('#profile-link-editor').modal('hide');
}

function refreshProfileLinkList() {
    $('#profile-link-editor').modal('hide');
    $('#profile-links-container').load('/profile_links?inline=yeah');
}

function doneWithAkaUpdate() {
    $('#aka_form_modal').modal('hide');
}

function miniflash(selector, type, message) {
    $(selector).append(
	$('<div class="alert alert-' + type + '">')
	    .append($('<button type="button" class="close" data-dismiss="alert">\u00d7</button>'))
	    .append($('<span>').text(message)));
}


