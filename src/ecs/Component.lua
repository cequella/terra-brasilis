return {
   new = function(id)
	  assert( id )
	  local Component = {
		 __id = id
	  }
	  return Component
   end
}
