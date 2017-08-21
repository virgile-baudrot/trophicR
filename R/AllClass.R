# This file is part of trophicR
#
# trophicR is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# trophicR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

setClass(Class = "trophicData",
         representation = representation(
           data_name = "list", # A list of function signature that would be returned by cxxfuncion 
           data_df = "data.frame"))

setClass(Class = "trophicModel",
         representation = representation(
           model_name = "character",
           model_code = "character"))


setClass(Class = "trophicFit",
         representation = representation(
           model_name = "character", 
           model_pars = "character", 
           par_dims = "list",
           model_type = "character"))
